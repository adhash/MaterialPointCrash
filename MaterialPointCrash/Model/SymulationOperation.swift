//
//  SymulationOperation.swift
//  MaterialPointCrash
//
//  Created by wojtek on 04/09/2020.
//

import Foundation
import UIKit

class SymulationOperation : Operation {
    private var stopButton: UIButton
    private var point1: MaterialPoint
    private var point2: MaterialPoint
    private var imgPoint1: UIImageView
    private var imgPoint2: UIImageView
    
    init(stopButton: UIButton, point1: MaterialPoint, point2: MaterialPoint, imgPoint1: UIImageView, imgPoint2: UIImageView) {
        self.imgPoint2 = imgPoint2
        self.imgPoint1 = imgPoint1
        self.point1 = point1
        self.point2 = point2
        self.stopButton = stopButton
    }
    
    override func main() {
        
        var dispatchTimeStart: DispatchTime = DispatchTime.now()
        var dispatchTimeEnd: DispatchTime = DispatchTime.now()
        var timeElapsed: UInt64
        var isRunning = true
        var collision = false
        
        while(isRunning) {
            timeElapsed = dispatchTimeEnd.uptimeNanoseconds - dispatchTimeStart.uptimeNanoseconds
            dispatchTimeStart = DispatchTime.now()
            
            DispatchQueue.main.sync {
                isRunning = self.stopButton.isEnabled
                self.imgPoint1.frame.origin.x += CGFloat(self.point1.x_speed * (Float(timeElapsed) / 1000000000.0))
                self.imgPoint2.frame.origin.x += CGFloat(self.point2.x_speed * (Float(timeElapsed) / 1000000000.0))
                
                let imgPoint1Edge = Int(self.imgPoint1.center.x + (self.imgPoint1.bounds.width / 2))
                let imgPoint2Edge = Int(self.imgPoint2.center.x - (self.imgPoint2.bounds.width / 2))
                
                if (imgPoint1Edge - imgPoint2Edge == 1) && !collision {
                    collision = true
                    
                    let weightsSum = (self.point1.weight + self.point2.weight)
                    self.point1.x_speed_prim = (((self.point1.weight - self.point2.weight) * self.point1.x_speed) + (2 * self.point2.weight * self.point2.x_speed)) / weightsSum
                    
                    self.point2.x_speed_prim = (((self.point2.weight - self.point1.weight) * self.point2.x_speed) + (2 * self.point1.weight * self.point1.x_speed)) / weightsSum
                    
                    self.point1.x_speed = self.point1.x_speed_prim!
                    self.point2.x_speed = self.point2.x_speed_prim!
                }
            }
            
            dispatchTimeEnd = DispatchTime.now()
        }
        print("elo")
    }
}
