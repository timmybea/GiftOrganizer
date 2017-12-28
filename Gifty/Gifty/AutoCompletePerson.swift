//
//  AutoCompletePerson.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class AutoCompletePerson: UIView {

    let profileImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ImageNames.profileImagePlaceHolder.rawValue))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let autoCompleteTF: MLPAutoCompleteTextField = {
        let textfield = MLPAutoCompleteTextField()
        textfield.font = Theme.fonts.mediumText.font
        textfield.placeholderWith(string: "Person's name", color: UIColor.white)
        return textfield
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
   
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupViews() {
        
        addSubview(profileImage)
        profileImage.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height)
        profileImage.layer.cornerRadius = profileImage.frame.width / 2

        addSubview(autoCompleteTF)
        autoCompleteTF.frame = CGRect(x: profileImage.frame.width + pad, y: self.bounds.height - 20, width: self.bounds.width - profileImage.frame.width - pad, height: 22)
        
        addSubview(whiteView)
        whiteView.frame = CGRect(x: autoCompleteTF.frame.origin.x, y: self.bounds.height - 2, width: autoCompleteTF.frame.width, height: 2)
    }
}

//func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, possibleCompletionsFor string: String!) -> [Any]! {
//    //provide complete list of person names
//
//    var persons = [Person]()
//    let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
//
//    do {
//        persons = try moc.fetch(fetchRequest)
//    } catch {
//        print(error)
//    }
//
//    var nameArray = [String]()
//
//    for person in persons {
//        if let name = person.name {
//            nameArray.append(name)
//        }
//    }
//
//    return nameArray
//}
//
//func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, didSelectAutoComplete selectedString: String!, withAutoComplete selectedObject: MLPAutoCompletionObject!, forRowAt indexPath: IndexPath!) {
//
//    let predicate = NSPredicate(format: "name == %@", selectedString)
//    let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
//    fetchRequest.predicate = predicate
//
//    var person: Person?
//
//    do {
//        person = try moc.fetch(fetchRequest).first
//    } catch {
//        print(error)
//    }
//
//    if let person = person {
//        if let imageData = person.image as? Data {
//            personImageView.image = UIImage(data: imageData)
//        }
//
//        if let name = person.name {
//            personNameTF.text = name
//        }
//    }

