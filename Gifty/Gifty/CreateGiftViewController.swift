//
//  CreateGiftViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-15.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

enum CreateGiftModes {
    case newGiftPersonUnknown
    case newGiftPersonKnown
    case editExistingGift
}

protocol CreateGiftViewControllerDelegate {
    func newGiftCreated()
}

class CreateGiftViewController: CustomViewController {
    
    func setupNewGiftFor(person: Person) {
        self.mode = .newGiftPersonKnown
        self.person = person
    }
    
    var delegate: CreateGiftViewControllerDelegate?
    
    private var mode: CreateGiftModes = .newGiftPersonUnknown
    
    var person: Person?
    private var giftName: String?
    
    //constants
    private var tabBarHeight: CGFloat! {
        return tabBarController?.tabBar.bounds.height ?? 48
    }
    
    private var navHeight: CGFloat! {
        return navigationController?.navigationBar.frame.height
    }
    
    private let statusHeight = UIApplication.shared.statusBarFrame.height
    
    private var saveButton: ButtonTemplate!
    
    private var scrollViewFrame: CGRect!
    
    //private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(sender:)))
    
    //UI Components
    private var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.layer.masksToBounds = true
        sv.backgroundColor = UIColor.clear
        sv.bounces = false
        sv.isPagingEnabled = false
        return sv
    }()
    
    lazy var giftNameTF: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.clear
        tf.placeholderWith(string: "Gift idea", color: UIColor.white)
        tf.autocapitalizationType = .words
        tf.returnKeyType = .done
        tf.keyboardType = .alphabet
        tf.textColor = UIColor.white
        tf.delegate = self
        return tf
    }()
    
    var autoCompletePerson: AutoCompletePerson?
    
    private var budgetView: BudgetView!
    
    let giftImageControl: CustomImageControl = {
        let v = CustomImageControl()
        v.setDefaultImage(UIImage(named: ImageNames.addGiftImage.rawValue)!)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        if mode != .newGiftPersonUnknown {
            navigationItem.hidesBackButton = true
            let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue),
                                             style: .plain,
                                             target: self,
                                             action: #selector(backButtonTouched(sender:)))
            self.navigationItem.leftBarButtonItem = backButton
        }

        navigationItem.title = "Create Gift"
        setupSubviews()
    }
    
    private func setupSubviews() {

        //saveButton
        let buttonframe = CGRect(x: pad,
                                 y: view.bounds.height - tabBarHeight - pad - 35,
                                 width: view.bounds.width - pad - pad,
                                 height: 35)
        saveButton = ButtonTemplate(frame: buttonframe)
        saveButton.setTitle("SAVE")
        saveButton.addBorder(with: UIColor.white)
        saveButton.addTarget(self, action: #selector(SaveButtonTouched), for: .touchUpInside)
        view.addSubview(saveButton)
        
        //scrollView
        scrollViewFrame = CGRect(x: pad,
                                 y: navHeight + statusHeight + pad,
                                 width: view.bounds.width - pad - pad,
                                 height: view.bounds.height - navHeight - statusHeight - pad - tabBarHeight - pad - 35)
        
        scrollView.frame = scrollViewFrame
        view.addSubview(scrollView)
        
        //giftImageControl
        let width = (scrollView.frame.width / 3)
        giftImageControl.frame = CGRect(x: scrollView.frame.width / 3, y: 0, width: width, height: width)
        scrollView.addSubview(giftImageControl)
        giftImageControl.addTarget(self, action: #selector(didTouchAddImage(sender:)), for: .touchUpInside)
        
        giftNameTF.frame = CGRect(x: 0, y: giftImageControl.frame.maxY + pad, width: scrollView.frame.width, height: 30)
        scrollView.addSubview(giftNameTF)
        
        let tfUnderline = UIView()
        tfUnderline.backgroundColor = UIColor.white
        tfUnderline.frame = CGRect(x: 0, y: giftNameTF.frame.maxY, width: scrollView.frame.width, height: 2)
        scrollView.addSubview(tfUnderline)
        
        //set budget
        let budgetLabel = Theme.createMediumLabel()
        budgetLabel.frame = CGRect(x: 0,
                                   y: tfUnderline.frame.maxY + pad,
                                   width: scrollView.bounds.width,
                                   height: 25)
        budgetLabel.text = "Set Budget"
        scrollView.addSubview(budgetLabel)
        
        var contentHeight = budgetLabel.frame.maxY + pad
        
        //budgetView
        budgetView = BudgetView(frame: CGRect(x: 0,
                                              y: budgetLabel.frame.maxY + pad,
                                              width: scrollView.bounds.width,
                                              height: 60))
        scrollView.addSubview(budgetView)
        
        if mode == .newGiftPersonUnknown {
            //autoCompletePerson
            let personLabel = Theme.createMediumLabel()
            personLabel.frame = CGRect(x: 0,
                                       y: budgetView.frame.maxY + pad,
                                       width: scrollView.bounds.width,
                                       height: 25)
            personLabel.text = "Set Person"
            scrollView.addSubview(personLabel)
            
            autoCompletePerson = AutoCompletePerson(frame: CGRect(x: 0,
                                                                  y: personLabel.frame.maxY + pad,
                                                                  width: scrollView.bounds.width,
                                                                  height: 100))
            self.autoCompletePerson?.autoCompleteTF.autocompleteDelegate = self
            scrollView.addSubview(autoCompletePerson!)
            contentHeight = autoCompletePerson!.frame.maxY + pad
        }
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: contentHeight)
    }

    private func createAlertForError(_ error: CustomErrors.createGift) {
        let alertController = UIAlertController(title: "Incomplete Gift", message: error.description, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //drop keyboard if editing textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc
    func handleKeyboardNotification(sender: Notification) {
        
        guard tabBarController?.selectedIndex == 2 else { return }
        guard let userInfo = sender.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if sender.name == Notification.Name.UIKeyboardWillShow {
            //keyboard up

            UIView.animate(withDuration: 0.0, animations: {
                self.scrollView.frame.size.height = self.view.bounds.height - self.navHeight - self.statusHeight - pad - keyboardFrame.height
                self.view.layoutIfNeeded()
            })
            
            //scroll to bottom
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - pad - (autoCompletePerson?.frame.origin.y)!)
            scrollView.setContentOffset(bottomOffset, animated: true)
        } else {
            scrollView.frame = scrollViewFrame
        }
    }
    
    @objc
    func didTouchAddImage(sender: CustomImageControl) {
        let options = ["Camera", "Photo library"]
        ActionSheetService.actionSheet(with: options, presentedIn: self) { (option) in
            switch option {
            case options[0]: self.launchCameraPicker()
            case options[1]: self.launchImagePicker()
            default: print("this should not be reached")
            }
        }
    }
    
    @objc
    func backButtonTouched(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: SAVE
    @objc
    func SaveButtonTouched() {
        //Save button
        let gb = GiftBuilder.newGift(dataPersistence: DataPersistenceService.shared)
        gb.addName(self.giftName)
        gb.addToPerson(self.person)
        gb.addCost(self.budgetView.getBudgetAmount())
        if let image = self.giftImageControl.getSelectedImage() {
            gb.addImage(image)
        }
        gb.canReturnGift { (success, error) in
            if success {
                gb.saveGiftToCoreData(DataPersistenceService.shared)
                
                //debugging
                let gift = gb.returnGift()
                print("NOT NIL:\(gift.image != nil)")
                
                
                //dismiss the vc depending on mode
                if self.mode == .newGiftPersonUnknown {
                    //clear everything
                    self.giftName = nil
                    self.person = nil
                    self.giftNameTF.text = ""
                    self.giftImageControl.returnToDefaultImage()
                    self.budgetView.setTo(amount: 0.0)
                    self.autoCompletePerson?.fullReset()
                    
                    AlertService.temporaryMessage("Gift created successfully", in: self, completion: {
                        self.tabBarController?.selectedIndex = UITabBarController.previousIndex
                    })
                } else {
                    self.delegate?.newGiftCreated()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            if let error = error {
                gb.deleteGiftFromCoreData(DataPersistenceService.shared)
                self.createAlertForError(error)
            }
        }
    }
}

//MARK: Autocomplete TF Delegate
extension CreateGiftViewController: AutoCompleteTextFieldDelegate {
   
    func provideDatasource() {
        //provide complete list of person names
        guard let allPeople = PersonFRC.frc(byGroup: false)?.fetchedObjects else { return }
        var nameArray = [String]()
        for person in allPeople {
            nameArray.append(person.fullName!)
        }
        autoCompletePerson?.autoCompleteTF.datasource = nameArray
    }
    
    func returned(with selection: String) {
        print("SELECTED: \(selection)")
        self.person = PersonFRC.person(with: selection)
        if self.person != nil {
            autoCompletePerson?.updateImage(with: person!.profileImage)
        }
    }
    
    func textFieldCleared() {
        autoCompletePerson?.resetProfileImage()
        self.person = nil
    }
}

//MARK: TextFieldDelegate
extension CreateGiftViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 30
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.giftNameTF.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var input = textField.text, input.count > 0 else { return }
        
        let firstChar = input.removeFirst()
        let capitalized = String(firstChar).uppercased() + input
        textField.text = capitalized
        
        self.giftName = capitalized
    }
    
}

//MARK: ImagePicker delegate methods
extension CreateGiftViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func launchImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("did cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if selectedImage != nil {
            if let scaledImage = UIImage.scaleImage(image: selectedImage!, toWidth: self.giftImageControl.frame.width, andHeight: giftImageControl.frame.height) {
                self.giftImageControl.setImage(scaledImage)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func launchCameraPicker() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            print("Camera entered")
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraDevice = .front
            picker.cameraCaptureMode = .photo
            picker.delegate = self

            present(picker, animated: true, completion: nil)
        } else {
            AlertService.okAlert(title: "No Camera", message: "This device has no camera", in: self)
        }
    }
}
