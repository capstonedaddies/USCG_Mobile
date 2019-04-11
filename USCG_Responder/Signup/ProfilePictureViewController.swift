//
//  ProfilePictureViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 3/28/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit
import Firebase

class ProfilePictureViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var dob: String?
    var address: String?
    var emergencyName: String?
    var emergencyPhone: String?
    var vesselNo: String?
    
    var photoURL: String?
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func next_button(_ sender: Any) {
        performSegue(withIdentifier: "profileimageToMedicalNotes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileimageToMedicalNotes" {
            let controller = segue.destination as! MedicalNotesViewController
            controller.firstName = firstName
            controller.lastName = lastName
            controller.email = email
            controller.password = password
            controller.dob = dob
            controller.address = address
            controller.emergencyName = emergencyName
            controller.emergencyPhone = emergencyPhone
            controller.vesselNo = vesselNo
            controller.photoURL = "photoURL"
            controller.image = profilePicture.image
            
            
        }
    }
    @IBAction func addPictureProfilePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Image", message: nil, preferredStyle: .alert)
        
        let takePicAction = UIAlertAction(title: "Take Photo", style: .default) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true, completion: nil)
            }
            
            
        }
        let libraryAction = UIAlertAction(title: "Select Photo", style: .default) { (action) -> Void in
            //launch library to get photo
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.modalPresentationStyle = .popover
            self.present(self.imagePicker,animated: true, completion: nil)
            
        }
        
        alert.addAction(takePicAction)
        alert.addAction(libraryAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let temp = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.profilePicture.image = temp!
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
