import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var symulationArea: UIView!
    @IBOutlet weak var weight1: UITextField!
    @IBOutlet weak var speed1: UITextField!
    @IBOutlet weak var weight2: UITextField!
    @IBOutlet weak var speed2: UITextField!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    private let borderWidth: CGFloat = 1
    private var point1Image: UIImageView?
    private var point2Image: UIImageView?
    private var operationQueque: OperationQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.symulationArea.layer.borderWidth = self.borderWidth
        self.symulationArea.layer.borderColor = UIColor.gray.cgColor
        self.stopButton.isEnabled = false;
        
        self.operationQueque = OperationQueue()
        self.operationQueque!.name = "symulation.queque"
    }

    @IBAction func on_start_click(_ sender: Any) {
        
        self.startButton.isEnabled = false
        
        let weight1Value = Float(self.weight1.text!)
        let weight2Value = Float(self.weight2.text!)
        let speed1Value = Float(self.speed1.text!)
        let speed2Value = Float(self.speed2.text!)
        
        let materialPiont1 = MaterialPoint(weight: weight1Value ?? 0, initialSpeed: speed1Value ?? 0)
        let materialPiont2 = MaterialPoint(weight: weight2Value ?? 0, initialSpeed: speed2Value == nil ? 0 : -speed2Value!)
        
        var renderer1 = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
        var img1 = renderer1.image { ctx in
            ctx.cgContext.setFillColor(UIColor.green.cgColor)
            ctx.cgContext.addEllipse(in: CGRect(x: 0, y: 0, width: 30, height: 30))
            ctx.cgContext.fillPath()
        }
        
        self.point1Image = UIImageView(image: img1)
        self.point1Image!.center.y = self.symulationArea.bounds.height / 2 - (2 * self.borderWidth)
        self.point1Image!.center.x = (self.point1Image!.bounds.width / 2) + self.borderWidth
        
        self.symulationArea.addSubview(self.point1Image!)
        
        renderer1 = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
        img1 = renderer1.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.addEllipse(in: CGRect(x: 0, y: 0, width: 30, height: 30))
            ctx.cgContext.fillPath()
        }
        
        self.point2Image = UIImageView(image: img1)
        self.point2Image!.center.y = self.symulationArea.bounds.height / 2 - (2 * self.borderWidth)
        self.point2Image!.center.x = self.symulationArea.bounds.width - (self.point2Image!.bounds.width / 2) - self.borderWidth
        
        self.symulationArea.addSubview(self.point2Image!)
        
        self.stopButton.isEnabled = true;
        
        operationQueque!.addOperation(SymulationOperation(stopButton: self.stopButton,
                                                         point1: materialPiont1,
                                                         point2: materialPiont2,
                                                         imgPoint1: self.point1Image!,
                                                         imgPoint2: self.point2Image!))
    }
    
    @IBAction func on_stop_click(_ sender: Any) {
        self.startButton.isEnabled = true
        self.stopButton.isEnabled = false
        self.point1Image!.removeFromSuperview()
        self.point2Image!.removeFromSuperview()
    }
}

