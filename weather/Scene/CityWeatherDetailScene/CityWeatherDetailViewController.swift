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

let reuseIDs = ["CityWeatherDetailViewControllerReuse0", "CityWeatherDetailViewControllerReuse1"]
class CityWeatherDetailViewController: UIViewController {
    @IBInspectable var reuseId:String!
    let disposeBag = DisposeBag()

    private let viewModel = CityWeatherDetailViewModel();
    @IBOutlet weak var cityNameLabel: UILabel!
    var panGR: UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
        
        bindData()
        // Do any additional setup after loading the view.
    }
    
    private func bindData(){
//        viewModel.rx_cityName.bind(to: cityNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.rx_cityName.bind(to: cityNameLabel.rx.text).disposed(by: disposeBag)
//        Observable.from(object: viewModel.city)


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
//                let cityIndex = cities.firstIndex(of: city!)!
                
                if nextState == .slidingLeft {
//                    nextVC?.city = cities[( cityIndex + 1 ) % cities.count]
                    
                    applyShrinkModifiers()
                    nextVC!.applySlideModifiers()
                    
                } else {
//                    nextVC?.city = cities[(cityIndex - 1 + cities.count) % cities.count]
                    
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
