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
    private let weatherLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setpuUI()
        let apiKey = "e050990db22df2ab58ab3c620741e32e"
        
        fetchWeather(for: "Seoul", apiKey: apiKey)
            .observe(on: MainScheduler.instance)
            .subscribe (onNext: { weather in
                let temperatureInCelsius = weather.main.temp - 273.15
                self.weatherLabel.text = "\(Int(temperatureInCelsius))"
                print("\(weather)")
            }, onError: { error in
                print("Error fetching weather: \(error.localizedDescription)")
                
            })
            .disposed(by: disposeBag)
    }

    private func setpuUI() {
        view.backgroundColor = UIColor(hex: "F4DFCD")

        view.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(230)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
    }
}







struct VCPreView:PreviewProvider {
    static var previews: some View {
        WeatherViewController().toPreview()
    }
}
