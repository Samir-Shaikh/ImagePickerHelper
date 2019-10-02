//
//  ImagePickerHelper.swift
//  Created by samir on 24/09/19.
//  Copyright © 2019 samir. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImagePickerHelper: NSObject {

    private struct PickerMediaType {
        
        static let image = kUTTypeImage as String
        static let video = kUTTypeMovie as String
    }
    
    //MARK: Variables
    static let shared = ImagePickerHelper()
    private var presentationController : UIViewController?
    private var completion : ((UIImage) -> ())?
    private var videoCompletion : ((URL) -> ())?
    
    //MARK: Private Methods
    private func getPickerController(sourceType: UIImagePickerController.SourceType, mediaType:String) -> UIImagePickerController{
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.mediaTypes = [mediaType]
        myPickerController.sourceType = sourceType
        return myPickerController
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String,mediaType:String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            let picker = self.getPickerController(sourceType: type, mediaType: mediaType)
            self.presentationController?.present(picker, animated: true)
        }
    }
    
    //MARK: Imagepicker controller
    func openImagePicker(for controller: UIViewController, completion: @escaping ((UIImage) -> ())){
        
        self.presentationController = controller
        self.completion = completion
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo", mediaType: PickerMediaType.image) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll", mediaType: PickerMediaType.image) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library", mediaType: PickerMediaType.image) {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = controller.view
            alertController.popoverPresentationController?.sourceRect = controller.view.frame
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    //MARK: Videopicker controller
    func openVideoPicker(for controller: UIViewController, completion: @escaping ( (URL) -> ())){
        
        self.presentationController = controller
        self.videoCompletion = completion
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take video", mediaType: PickerMediaType.video) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll", mediaType: PickerMediaType.video) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library", mediaType: PickerMediaType.video) {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = controller.view
            alertController.popoverPresentationController?.sourceRect = controller.view.frame
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
  
}

//MARK:- UIImagePickerController Delegates
extension ImagePickerHelper : UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        self.presentationController?.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            
            //image picker
            self.presentationController?.dismiss(animated: true, completion: {
                
                self.completion?(image)
            })
        }
        else if let url = info[.mediaURL] as? URL{
            
            //video url
            self.presentationController?.dismiss(animated: true, completion: {
                
                self.videoCompletion?(url)
            })
        }
        
    }
}
