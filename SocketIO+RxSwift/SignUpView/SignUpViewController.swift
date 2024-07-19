//
//  SignUpViewController.swift
//  SocketIO+RxSwift
//
//  Created by hansol on 2024/07/02.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setTapGesture() {
        signUpView.signUpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let viewModel = self?.viewModel else { return }
//                self?.navigationController?.pushViewController(ListViewController(viewModel), animated: true)
            })
            .disposed(by: disposeBag)
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



