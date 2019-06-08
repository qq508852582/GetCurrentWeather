//
//  CityWeatherDetailViewController.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/6.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Hero
import Kingfisher
let reuseIDs = ["CityWeatherDetailViewControllerReuse0", "CityWeatherDetailViewControllerReuse1"]
class CityWeatherDetailViewController: UIViewController {
    @IBInspectable var reuseId:String!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionIcon: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    @IBOutlet weak var updateTimeValueLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var city:CityWeatherModel?{
        didSet{
            self.viewModel.city = self.city
        }
    }
    
    let disposeBag = DisposeBag()
    private let viewModel = CityWeatherDetailViewModel();
    var panGR: UIPanGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
        bindData()
        // Do any additional setup after loading the view.
    }
    
    private func bindData(){
        viewModel.rx_cityName.bind(to: cityNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.rx_cityName.subscribe(onNext:{[weak self] in
            self?.cityNameLabel.hero.id = $0
            self?.conditionIcon.hero.id = "\($0):icon"
            self?.temperatureLabel.hero.id = "\($0):temperature"
        }).disposed(by: disposeBag)
        
        viewModel.rx_temperature.bind(to: temperatureLabel.rx.text).disposed(by: disposeBag)
        viewModel.rx_conditionText.bind(to: conditionLabel.rx.text).disposed(by: disposeBag)
        viewModel.rx_windSpeed.bind(to: windSpeedValueLabel.rx.text).disposed(by: disposeBag)
        viewModel.rx_updateTime.bind(to: updateTimeValueLabel.rx.text).disposed(by: disposeBag)
        viewModel.rx_conditionIcon.subscribe(onNext:{
            self.conditionIcon.kf.setImage(with: $0)
        }).disposed(by: disposeBag)
        viewModel.rx_cityIndex.bind(to: pageControl.rx.currentPage).disposed(by: disposeBag)
        viewModel.rx_citiesNumber.bind(to: pageControl.rx.numberOfPages).disposed(by: disposeBag)

        
    }
    @IBAction func menuButtonAction(_ sender: Any) {
       let listVC = self.storyboard!.instantiateViewController(withIdentifier: "cityList") as! CityWeatherListViewController
        hero.replaceViewController(with: listVC)
    }
    
    
    func applyShrinkModifiers() {
        view.hero.modifiers = nil
        //        detailView.hero.modifiers = [.translate(x:-50, y:(view.center.y - detailView.center.y)/10), .scale(0.9), HeroModifier.duration(0.3)]
        
    }
    
    func applySlideModifiers() {
        view.hero.modifiers = [.translate(x: view.bounds.width), .duration(0.3), .beginWith(modifiers: [.zPosition(2)])]
        
    }
    
    var transitionState: TransitionState = .normal
    weak var nextVC: CityWeatherDetailViewController?

    @objc func pan() {
        let translateX = panGR.translation(in: nil).x
        let velocityX = panGR.velocity(in: nil).x
        switch panGR.state {
        case .began, .changed:
            let nextState: TransitionState
            if transitionState == .normal {
                nextState = velocityX < 0 ? .slidingLeft : .slidingRight
            } else {
                nextState = translateX < 0 ? .slidingLeft : .slidingRight
            }
            
            if nextState != transitionState {
                Hero.shared.cancel(animate: false)
                let currentIndex = reuseIDs.firstIndex(of: reuseId)!
                let nextIndex = (currentIndex + (nextState == .slidingLeft ? 1 : reuseIDs.count - 1)) % reuseIDs.count
                nextVC = self.storyboard!.instantiateViewController(withIdentifier: reuseIDs[nextIndex]) as? CityWeatherDetailViewController
                
                if nextState == .slidingLeft {
                    nextVC?.viewModel.city = self.viewModel.nextCity
                    
                    applyShrinkModifiers()
                    nextVC!.applySlideModifiers()
                    
                } else {
                    nextVC?.viewModel.city = self.viewModel.previousCity

                    applySlideModifiers()
                    nextVC!.applyShrinkModifiers()
                }
                transitionState = nextState
                hero.replaceViewController(with: nextVC!)
            } else {
                let progress = abs(translateX / view.bounds.width)
                Hero.shared.update(progress)
                if transitionState == .slidingLeft, let nextVC = nextVC {
                    Hero.shared.apply(modifiers: [.translate(x: view.bounds.width + translateX)], to: nextVC.view)
                } else {
                    Hero.shared.apply(modifiers: [.translate(x: translateX)], to: view)
                }
            }
        default:
            let progress = (translateX + velocityX) / view.bounds.width
            if (progress < 0) == (transitionState == .slidingLeft) && abs(progress) > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
            transitionState = .normal
        }
    }

}
