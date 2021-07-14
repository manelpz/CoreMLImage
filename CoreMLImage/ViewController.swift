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
        dataLabel.text = "Cargando ..."
        guard let model = try? VNCoreMLModel(for: YOLOv3Tiny().model) else {
            print("Error loading the model")
            return
        }
        
        let request  = VNCoreMLRequest(model: model){
            (request, error) in
            
            guard let result = request.results as? [VNClassificationObservation],
                  let firstResult
        }
    }
    
    //System Functions
    


}

