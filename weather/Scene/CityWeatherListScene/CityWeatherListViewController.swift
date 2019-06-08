//
//  CityWeatherListViewController.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/6.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CityWeatherListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel = CityWeatherListViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        //bind data
        Observable.collection(from: viewModel.cities)
                .bind(to: tableView.rx.items) { (collectionView, row, city) in
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = collectionView.dequeueReusableCell(withIdentifier: CityWeatherListTableViewCell.identifier, for: indexPath) as! CityWeatherListTableViewCell
                    cell.city = city
                    return cell
                }
                .disposed(by: disposeBag)

        tableView.rx.modelSelected(CityWeatherModel.self).subscribe(onNext: { [weak self] city in

            let listVC = self?.storyboard!.instantiateViewController(withIdentifier: reuseIDs.first!) as! CityWeatherDetailViewController
            listVC.city = city
            self?.hero.replaceViewController(with: listVC)

        }).disposed(by: disposeBag)
    }

    @IBAction func addCityAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Sorry",
                message: "It's not designed yet？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)

    }
}
