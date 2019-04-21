//
//  ViewController.swift
//  System View Controllers
//
//  Created by Viktor on 20/04/2019.
//  Copyright © 2019 Viktor Chernykh. All rights reserved.
//

import MessageUI
import SafariServices

class ViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - IB Actions
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        
        let activityController = UIActivityViewController(
            activityItems: [image],     // send list items
            applicationActivities: nil  // optional list of actions that can be performed with these items
        )
        
        activityController.popoverPresentationController?.sourceView = view
        activityController.popoverPresentationController?.sourceRect = sender.frame
        present(activityController, animated: true)
    }
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        let url = URL(string: "http://apple.ru")!
        let safariViewController = SFSafariViewController(url: url)
        
        present(safariViewController, animated: true)
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                print(#function, "Camera selected")
                // TODO: TODO: Implement camera selection
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = sender.frame
        present(alertController, animated: true)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            print(#line, #function, "Can not send e-mail")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients(["v-cher9@yandex.ru"])
        mailComposer.setSubject("Please help with my homework")
        mailComposer.setMessageBody("Hello, please help me with the following...", isHTML: false)

        if let imageData = imageView.image!.jpegData(compressionQuality: 1) {
            mailComposer.addAttachmentData(imageData, mimeType: "application/jpg", fileName: "nature")
        }
        
        mailComposer.popoverPresentationController?.sourceView = view
        mailComposer.popoverPresentationController?.sourceRect = sender.frame
        present(mailComposer, animated: true)
    }
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        guard MFMessageComposeViewController.canSendText() else {
            print(#line, #function, "Can not send message")
            return
        }
        let messageComposer = MFMessageComposeViewController()

        
        messageComposer.body = "Hi, how do you do?"
        messageComposer.recipients = ["79624036398"]
        messageComposer.messageComposeDelegate = self

        if MFMessageComposeViewController.canSendAttachments() {
            if let imageData = imageView.image!.jpegData(compressionQuality: 1) {
                messageComposer.addAttachmentData(imageData, typeIdentifier: "public.data", filename: "nature.jpg")
            }
        }
        
        messageComposer.popoverPresentationController?.sourceView = view
        messageComposer.popoverPresentationController?.sourceRect = sender.frame
        present(messageComposer, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let data = info[UIImagePickerController.InfoKey.originalImage] else { return }
        let image = data as? UIImage
        imageView.image = image
        dismiss(animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch (result) {
        case .cancelled: print("Message was cancelled")
        case .failed: print("Message failed")
        case .sent: print("Message was sent")
        default:
            break
        }
        dismiss(animated: true)
    }
}

// MARK: - MFMessageComposeViewControllerDelegate
extension ViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result) {
        case .cancelled: print("Message was cancelled")
        case .failed: print("Message failed")
        case .sent: print("Message was sent")
        default:
            break
        }
        dismiss(animated: true)
    }
}
