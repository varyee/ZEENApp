//
//  ViewController.swift
//  ZEEN
//
//  Created by Ayele  Aryee on 6/7/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure correct view is shown at launch
        switchViews(segmentedControl)
    }
    
    //Method to switch the views
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            firstView.alpha = 1
            secondView.alpha = 0
        }
        else {
            firstView.alpha = 0
            secondView.alpha = 1
        }
    }
    
    
}
