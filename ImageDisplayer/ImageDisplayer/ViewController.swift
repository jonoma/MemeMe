//
//  ViewController.swift
//  ImageDisplayer
//
//  Created by Jonathan Matusky on 1/18/16.
//  Copyright © 2016 Jonathan Matusky. All rights reserved.
//

import UIKit

struct Meme {
    var memeTopText: String
    var memeBottomText: String
    var memeOriginalImage: UIImage?
    var memeImage: UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        
        self.topText.delegate = self
        self.bottomText.delegate = self
        topText.text = "[Top Text]"
        bottomText.text = "[Bottom Text]"
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSBackgroundColorAttributeName : UIColor.clearColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func save() {
        //Create the meme
        let meme = Meme(memeTopText: topText.text!, memeBottomText: bottomText.text!, memeOriginalImage: imageDisplay.image, memeImage: memeImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func memeImage() -> UIImage {
        //Create the meme
        toolbar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toolbar.hidden = false
        
        return memedImage
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: [NSObject : AnyObject] = notification.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in self.view.frame.origin.y -= keyboardSize.height
                } )
            } else {
                UIView.animateWithDuration(0.1, animations: { () -> Void in self.view.frame.origin.y += keyboardSize.height - offset.height
                })
            }
        }
        //view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageDisplay.image = image
            self.imageDisplay.contentMode = .ScaleAspectFill
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }

    @IBAction func takeAPhoto(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        var memeObjects: [AnyObject] = []
        let image = memeImage()
        
        memeObjects.append(image)
        
        let activityViewController = UIActivityViewController(activityItems: memeObjects, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        save()
    }
}

