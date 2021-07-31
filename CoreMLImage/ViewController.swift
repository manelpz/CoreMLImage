//
//  ViewController.swift
//  CoreMLImage
//
//  Created by Emmanuel Lopez Guerrero on 12/07/21.
//ff

import UIKit
import Vision
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //detectImage()
        TakePhotoButton.layer.cornerRadius =  TakePhotoButton.bounds.size.height/2
        SelectButton.layer.cornerRadius = SelectButton.bounds.size.height/2
    }
    
    //variables
    
    //IBOutlet
    @IBOutlet var dataImage: UIImageView!
    @IBOutlet var dataLabel: UILabel!

    @IBOutlet var TakePhotoButton: UIButton!
    @IBOutlet var SelectButton: UIButton!
    
    //IBAction
    @IBAction func takePhoto(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            fatalError("No access allowed to camera")
        }
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("Unable to access photo library")
        }
    }
    
    //Functions
    func detectImage(){
        dataLabel.text = "Loading..."
        //maskDetectionModel
        //MobileNet
        guard let model = try? VNCoreMLModel(for: maskDetectionModel().model) else{
            print("Error loading the model")
            return
        }
        
        let request  = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation],
                  let firstResult = result.first else {
                    self.dataLabel.text = "Not found results"
                self.dataLabel.textColor = UIColor.red
                    return
            }
            
            DispatchQueue.main.async {
                self.dataLabel.text = "\(firstResult.identifier)\(Int(firstResult.confidence * 100))%"
                self.dataLabel.textColor = UIColor.blue
            }
        }
        
        guard let ciimage = CIImage(image: self.dataImage.image!) else{
            print("CIImage not loaded from UIImage")
            return
        }
        
        
        
        //run request
        
        let handler = VNImageRequestHandler(ciImage: ciimage)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                try handler.perform([request])
            }catch{
                print(error.localizedDescription)
            }
            
           
        }
        
        
    }
    
    //System Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.dataImage.image = pickedImage
            self.dataImage.contentMode = .scaleAspectFill
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        detectImage()
    }


}

