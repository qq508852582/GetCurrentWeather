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
    let viewModel = CityWeatherListViewModel();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.from( viewModel.cities)
            .bind(to: tableView.rx.items){ [weak self] (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(                    withIdentifier: CityWeatherListTableViewCell.identifier,                    for: indexPath) as! CityWeatherListTableViewCell
//                cell.config(element)
                return cell
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
