//
//  ViewController.swift
//  MyFirst
//
//  Created by iwama on 2019/07/10.
//  Copyright © 2019 iwama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  
    }

    @IBOutlet weak var answerImageView: UIImageView!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    var answerNumber = 0
    
    @IBAction func shuffleAction(_ sender: Any) {
        answerNumber = Int(arc4random_uniform(3))
        
        if answerNumber == 0 {
            answerLabel.text = "グー "
            answerImageView.image = UIImage(named:"gu")
        } else if answerNumber == 1 {
            answerLabel.text = "チョキ "
            answerImageView.image = UIImage(named:"choki")
        } else if answerNumber == 2 {
            answerLabel.text = "パー "
            answerImageView.image = UIImage(named:"pa")
        }
        
    }
}

