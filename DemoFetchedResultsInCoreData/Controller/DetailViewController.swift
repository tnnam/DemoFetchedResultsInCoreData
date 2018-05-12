//
//  ViewController.swift
//  DemoFetchedResultsInCoreData
//
//  Created by Tran Ngoc Nam on 5/11/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure()
    }
    
    func configure() {
        if person != nil {
            nameTextField.text = person!.name
            ageTextField.text = String(person!.age)
            photoImageView.image = person!.photo as? UIImage 
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        photoImageView.image = selectImage
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let masterViewController = segue.destination as? MasterTableViewController {
            var ageValue: Int?
            if ageTextField.text != "" {
                ageValue = Int(ageTextField.text!)
            }
            if masterViewController.tableView.indexPathForSelectedRow == nil {
                // add new - create a new object
                person = Person(context: masterViewController.fetchedResultsController.managedObjectContext)
            }
            person!.age = Int32(ageValue!)
            person!.name = nameTextField.text
            person!.photo = photoImageView.image
            DataService.shared.saveToCoreData()
        }
    }
}
