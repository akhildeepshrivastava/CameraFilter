//
//  ViewController.swift
//  CameraFilter
//
//  Created by Shweta Shrivastava on 1/18/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let photoCVC = navC.viewControllers.first as? PhotCollectoionViewController else {
            fatalError("Segue destination is not found")
        }
        photoCVC.selectedPhoto.subscribe { [weak self] (image) in
            DispatchQueue.main.async {
                self?.updateUI(with: image)

            }
        }.disposed(by: disposeBag)
    }

    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
        
    }
    @IBAction func applyFilter() {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FiltersService().applyFilter(to: sourceImage).subscribe { (image) in
            self.photoImageView.image = image
        }.disposed(by: disposeBag)

    }
}

