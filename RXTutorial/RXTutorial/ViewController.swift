//
//  ViewController.swift
//  RXTutorial
//
//  Created by Ice on 9/4/2562 BE.
//  Copyright © 2562 Ice. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var userField: UITextField!
  @IBOutlet weak var passField: UITextField!
  @IBOutlet weak var loginBtn: UIButton!
  @IBOutlet weak var labelText: UILabel!
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textUpdate()
    loginBtn.isEnabled = false
    inChangedButton()
  }
  
  //MARK: - Auto Print Text
  func textUpdate() {
    Observable<Void>.create { (observer) -> Disposable in
      print("Disposeables")
      return Disposables.create {
        print("DisposeX")
      }
    }
    
      textField
        .rx
        .text
        .orEmpty
        .asObservable()
        .subscribe(onNext: { (str) in
          print("TextField1 str: [\(str)]")
          self.labelText.text = str
        })
        .disposed(by: disposeBag)
  }

  //MARK: - Check Valid TextField
  func inChangedButton() {
    let user = userField.rx
      .text
      .orEmpty
      .asObservable()
      .map { (str) -> Bool in
        return str.characters.count > 4
      }
    
    let pass = passField.rx
      .text
      .orEmpty
      .asObservable()
      .map { (pass) -> Bool in
        return pass.characters.count > 4
    }
    
    Observable
      .combineLatest(user,pass)
      { (isUserValid, isPassValid) in
          return isPassValid && isPassValid
      }
      .bind(to: loginBtn.rx.isEnabled)
    
  }
  
  //MARK: - Binding TextField
  func bindtextField() {
    
  }

}

