import Foundation

class MaterialPoint {
    var x_speed: Float
    var x_speed_prim: Float?
    let weight: Float
    
    init(weight: Float, initialSpeed: Float) {
        self.weight = weight
        self.x_speed = initialSpeed
    }
}
