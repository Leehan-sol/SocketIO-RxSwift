//
//  SignUpViewController.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class SignUpViewController: UIViewController {
    private let signUpView = SignUpView()
    private let viewModel = SignUpViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTapGesture()
        setBindings()
    }

    
    private func setTapGesture() {
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        signUpView.signUpButton.rx.tap
            .withLatestFrom(signUpView.signUpTextField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] nickname in
                guard let self = self else { return }
                let listViewModel = ListViewModel(nickname: nickname)
                let listViewController = ListViewController(listViewModel)
                self.navigationController?.pushViewController(listViewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setBindings() {
        let nickname = signUpView.signUpTextField.rx.text
            .map { $0?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }
            .asObservable()
        
        let input = SignUpViewModel.SignUpInput(nickname: nickname)
        let output = viewModel.transform(input: input)
        
        output.validNickname
            .bind(to: signUpView.signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    
    
}



