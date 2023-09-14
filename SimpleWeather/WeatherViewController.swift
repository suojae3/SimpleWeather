//
//  ViewController.swift
//  SimpleWeather
//
//  Created by ㅣ on 2023/09/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SwiftUI



class WeatherViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = WeatherViewModel()
    
    private let sunnyGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "FFF5E4").withAlphaComponent(0.2).cgColor, UIColor(hex: "FF9494").withAlphaComponent(0.6).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.type = .axial
        return gradientLayer
    }()
    
    private let rainyGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "F8FDCF").withAlphaComponent(0.2).cgColor, UIColor(hex: "78C1F3").withAlphaComponent(0.6).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.type = .axial
        return gradientLayer
    }()
    
    private let cloudyGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "FFFFD0").withAlphaComponent(0.2).cgColor, UIColor(hex: "A555EC").withAlphaComponent(0.6).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.type = .axial
        return gradientLayer
    }()
    
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setpuUI()
        setupContstaints()
        bindViewModel()
    }
    
    private func setpuUI() {
        view.addSubview(weatherLabel)
        view.layer.addSublayer(cloudyGradientLayer)
        weatherViewConstraints()
    }
    
    private func setupContstaints() {
        weatherLabel.textAlignment = .center
    }
    
    
    private func bindViewModel() {
        let input = WeatherViewModel.Input(fetchWeatherTrigger: Observable.just(()))
        
        let output = viewModel.transform(input: input)
        output.temperature
            .bind(to: weatherLabel.rx.text)
            .disposed(by: disposeBag)
        output.errorMessage
            .subscribe(onNext: { [weak self] message in
                print(message)
            })
            .disposed(by: disposeBag)
    }
    
    private func cityLabel() {
        
    }
    
    private func dateLabel() {
        
    }
    
    private func weatherIcon() {
        
    }
    
    
    private func weatherViewConstraints() {
        
        //backgroundLayer
        sunnyGradientLayer.frame = view.bounds
        rainyGradientLayer.frame = view.bounds
        cloudyGradientLayer.frame = view.bounds
        
        //weatherLabel
        weatherLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(230)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
    }
}

struct VCPreView:PreviewProvider {
    static var previews: some View {
        WeatherViewController().toPreview().edgesIgnoringSafeArea(.all)
    }
}

