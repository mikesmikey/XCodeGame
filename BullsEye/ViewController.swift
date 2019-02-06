//
//  ViewController.swift
//  BullsEye
//
//  Created by informatics on 9/1/2562 BE.
//  Copyright © 2562 Jeffware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentValue: Int = 0
    var targetValue: Int = 0
    
    var totalScore: Int = 0
    var round: Int = 0
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targelLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")!
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = UIImage(named: "SliderTrackLeft")!
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = UIImage(named: "SliderTrackRight")!

        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
        
        startNewRound()
    }
    
    func showAlert(points: Int ,bonus: Int,rankWord: String) {
        let message = "แต้มของคุณคือ: \(points)\n" + "โบนัส +\(bonus)"
        
        let alert = UIAlertController(title: rankWord, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction( title: "ตกลง", style: .default, handler: { action in self.startNewRound() })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func silderMoved (_ slider: UISlider) {
        currentValue = lroundf(slider.value)
        //print("\(currentValue)")
    }
    
    @IBAction func submitAction() {
        let difference = abs(currentValue - targetValue)
        let points = 100 - difference
        let rank = defineRank(difference: difference)
        let bonus = calculateExtraScore(rank: rank)
        
        updateTotalScore(points: points+bonus)
        updateRound()
        showAlert(points: points,bonus: bonus, rankWord: defineRankString(rank: rank))
    }
    
    func calculateExtraScore(rank: Int) -> Int {
        let extra: Int
        
        if rank == 3 {
            extra = 100
        } else if rank == 2 {
            extra = 50
        } else if rank == 1 {
            extra = 25
        } else {
            extra = 0
        }
        
        return extra
    }
    
    func defineRank(difference: Int) -> Int {
        
        switch difference {
            case 0:
                return 3
            case 0..<5:
                return 2
            case 0..<10:
                return 1
            default:
                return 0
        }
    }
    
    func defineRankString(rank: Int) -> String {
        let word: String
        
        if rank == 3 {
            word = "คุณโคตรเทพ!"
        } else if rank == 2 {
            word = "คุณตาดีมาก!"
        } else if rank == 1 {
            word = "พอใช้ได้!"
        } else {
            word = "กาก"
        }
        
        return word
    }
    
    func startNewRound() {
        targetValue = Int.random(in: 1...100)
        currentValue = 50
        slider.value = Float(currentValue)
        updateLabels()
    }
    
    func updateTotalScore(points:Int) {
        totalScore += points
    }
    
    func updateRound() {
        round += 1
    }
    
    func updateLabels() {
        targelLabel.text = String(targetValue)
        totalScoreLabel.text = String(totalScore)
        roundLabel.text = String(round)
    }
    
    @IBAction func startNewGame() {
        round = 0
        totalScore = 0
        
        startNewRound()
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        view.layer.add(transition, forKey: nil)
    }
}

