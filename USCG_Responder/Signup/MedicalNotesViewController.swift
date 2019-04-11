//
//  MedicalNotesViewController.swift
//  USCG_Responder
//
//  Created by Mark Vainauskas on 3/28/19.
//  Copyright © 2019 Patrick Flynn. All rights reserved.
//

import UIKit
import Firebase

class MedicalNotesViewController:UIViewController{
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
    var image: UIImage?
    @IBOutlet weak var medicalNotes: UITextView!
    
    var handle:AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        var errorMessage:String?
        
        Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
            
            guard let user = authResult?.user
                else {
                    errorMessage = "Error Authenticating. Double check and try again."
                    let alertController = UIAlertController(title: "Attention!", message: errorMessage, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "submitToLogin", sender: nil)
                    }))
                    
                    self.present(alertController,animated: true,completion: nil)
                    return
            }
            Auth.auth().currentUser?.sendEmailVerification { (error) in
                if error != nil{
                    print(error!)
                    errorMessage = "Email verification failed. Please use valid Email address."
                    let alertController = UIAlertController(title: "Attention!", message: errorMessage, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "submitToLogin", sender: nil)
                    }))
                    
                    self.present(alertController,animated: true,completion: nil)
                }
                else{
                    errorMessage = "Authentication email sent. Pleae check email and then try signing in."

                    let myID = authResult?.user.uid
                    
                    self.uploadImage(uid: myID!, image: self.image!, completionBlock: {[weak self] (fileURL, error) in
                        guard let strongSelf = self else{
                            return
                        }
                        print(fileURL)
                        
                    })
                    
                    let ref: DatabaseReference = Database.database().reference(withPath: "user_locations").child(myID!)
                    
                    let userCredentials = ["First Name": self.firstName!,
                                           "Last Name": self.lastName!,
                                           "Email":self.email!,
                                           "DOB": self.dob!,
                                           "Address": self.address!,
                                           "Emergency Contact Name": self.emergencyName!,
                                           "Emergency Contact Phone": self.emergencyPhone!,
                                           "Vessel No": self.vesselNo!,
                                           "Photo": self.photoURL!,
                                           "Medical Notes": self.medicalNotes.text!,
                                           "lat": "0.00000",
                                           "lon": "0.00000",
                                           "mayday": "false"] as [String : Any]
                    
                    ref.setValue(userCredentials);
                    
                    let alertController = UIAlertController(title: "Attention!", message: errorMessage, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "submitToLogin", sender: nil)
                    }))
                    
                    self.present(alertController,animated: true,completion: nil)
                    
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submitToLogin" {
            let controller = segue.destination as! SignInViewController
            //controller.noBlank.text = errorMessage!
            //controller.noBlank.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            //controller.noBlank.isHidden = false
        }
    }
    
    func uploadImage(uid: String, image: UIImage,completionBlock: @escaping (_ url: URL?, _ error: String?)-> Void){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let userImageRef = storageRef.child("images/\(uid).jpg")
        if let imageData = UIImageJPEGRepresentation(image, 0.2){
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = userImageRef.putData(imageData , metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata{
                    userImageRef.downloadURL{(url, error) in
                        guard let downloadURL = url else{
                            return
                        }
                        completionBlock(url,nil)
                        self.photoURL = downloadURL.absoluteString
                        print("image successfully updated")
                    }
                }else{
                    completionBlock(nil,error?.localizedDescription)
                }
            })
        } else{
            completionBlock(nil,"Image not converted")
        }
        
    }
}
