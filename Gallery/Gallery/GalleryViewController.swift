//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Dmitriy Budanov on 25.04.2022.
//

import UIKit
import Photos
import Alamofire
import Kingfisher

class GalleryViewController: UIViewController, UICollectionViewDelegate,  UINavigationControllerDelegate {
    
    // MARK: - Public properties
    var myCollectionView: UICollectionView!
    var imageArray = [UIImage]()
    var imageArray2 = [UIImage]()
    var count:CGFloat = 3
    
    @IBOutlet var gestureRecognizer: UIPinchGestureRecognizer!
    
    // MARK: - Override methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMyCollectionView()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private methods
    
   
    
    private func setUpMyCollectionView() {
        self.title = "Photos"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPictures))
        let layout = UICollectionViewFlowLayout()
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(GalleryViewCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(myCollectionView)
        myCollectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    
    
    private func takePhotos(){
        imageArray = []
        DispatchQueue.global(qos: .userInteractive).async {
            print("This is run on the background queue")
            let imgManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            let fetchOptions=PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult)
            print(fetchResult.count)
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageArray.append(image!)
                        DispatchQueue.main.async {
                            self.myCollectionView.reloadData()
                        }
                    })
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.takePhotos()
                }
            }
            print("imageArray count: \(self.imageArray.count)")
            
        }
        
    }
    
    private func saveImage(imageName: String, image: UIImage) {
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        UserDefaultKeyses.shared.pictureName.append(imageName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }
    
    func showAlertWithTextField() {
            let alertController = UIAlertController(title: "Add new picture from internet", message: nil, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Download", style: .default) { (_) in
                if let txtField = alertController.textFields?.first, let text = txtField.text {
                    self.dowloadPictureWithUrl(pictureUrl: text)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            alertController.addTextField { (textField) in
                textField.placeholder = "URL"
            }
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    
    private func loadImageFromDiskWith(fileName: String) -> UIImage? {
      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    private func dowloadPictureWithUrl(pictureUrl:String) {
        DispatchQueue.global(qos: .userInteractive).async {
        AF.request( pictureUrl ,method: .get).response { response in
        switch response.result {
        case .success(let responseData):
           self.saveImage(imageName: UUID().uuidString, image: UIImage(data: responseData!, scale:1) ?? UIImage())
           self.imageArray.append(UIImage(data: responseData!, scale:1) ?? UIImage())
           self.myCollectionView.reloadData()

        case .failure(let error):
            print("error--->",error)
            }
            }
        }
    }

    @objc func addPictures() {
        self.popupAlert(title: "Add pictures", message: "Choose directory", actionTitles: ["Gallery","Add picture from internet","Show picture from secret gallery"], actions:[
            { action1 in
            self.openGallery()
        },{ action2 in
            self.showAlertWithTextField()
        },{ action3 in
            self.imageArray.removeAll()
                for names in UserDefaultKeyses.shared.pictureName {
                    self.imageArray.append(self.loadImageFromDiskWith(fileName: names) ?? UIImage())
                }
            self.myCollectionView.reloadData()
        },nil])
    }
}

// MARK: - UICollectionViewDataSource

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GalleryViewCell
    cell.img.image=imageArray[indexPath.item]
    return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    return CGSize(width: width/count - 1, height: width/count - 1)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

private extension GalleryViewController {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension GalleryViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            saveImage(imageName: UUID().uuidString, image: pickedImage)
            imageArray.append(pickedImage)
            self.myCollectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


