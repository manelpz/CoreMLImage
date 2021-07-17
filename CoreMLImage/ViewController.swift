//
//  ViewController.swift
//  CoreMLImage
//
//  Created by Emmanuel Lopez Guerrero on 12/07/21.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detectImage()
    }
    
    //variables
    
    //IBOutlet
    
    @IBOutlet var dataImage: UIImageView!
    @IBOutlet var dataLabel: UILabel!
    
    //IBAction
    
 
    @IBAction func takePhoto(_ sender: Any) {
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
    }
    
    //Functions
    
    func detectImage(){
        dataLabel.text = "Loading..."
        
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else{
            print("Error loading the model")
            return
        }
        
        let request  = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let result = request.results as? [VNClassificationObservation],
                  let firstResult = result.first else {
                self.dataLabel.text = "Not found results"
                return
            }
            
            DispatchQueue.main.async {
                self.dataLabel.text = "\(firstResult.identifier)"
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
    


}

