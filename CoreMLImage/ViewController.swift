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
        
        //roudned buttons
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
    /*@IBAction func takePhoto(_ sender: Any) {
       
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            fatalError("No access allowed to camera")
        }
    }*/
    
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
        self.dataLabel.textColor = UIColor.lightGray

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
                var textModelDetection = ""
                let matchModelDetection = firstResult.identifier
                
                switch matchModelDetection {
                case "with_mask":
                    textModelDetection = "Wearing mask with "
                    self.dataLabel.textColor = UIColor.gray//(hue: 0.3222, saturation: 1, brightness: 0.68, alpha: 1.0)
                case "without_mask":
                    textModelDetection = "No wearing mask with "
                    self.dataLabel.textColor = UIColor.gray//(hue: 0.9972, saturation: 1, brightness: 0.76, alpha: 1.0)
                case "mask_weared_incorrect":
                    textModelDetection = "Mask weared incorrect with "
                    self.dataLabel.textColor = UIColor.gray//(hue: 0.0944, saturation: 1, brightness: 0.86, alpha: 1.0)
                default:
                    textModelDetection = "0 Results found "
                }
                
                self.dataLabel.text = " \(textModelDetection)\(Int(firstResult.confidence * 100))% of confidence"
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

