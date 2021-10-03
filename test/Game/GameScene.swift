//
//  GameScene.swift
//  test
//
//  Created by evilb on 02.10.2021.
//

import SpriteKit

class GameScene: SKScene {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var bg = SKSpriteNode(imageNamed: "bgImage")
    var circle = SKSpriteNode(imageNamed: "circle_blue")
    var startButton = SKSpriteNode(imageNamed: "pressStart")
    var velocity = CGPoint.zero
    let playableRect: CGRect
    
    var score = 0
    
    var timerLabel = SKLabelNode(fontNamed: "ArialMT")

    var timerValue: Int = 0 {
        didSet {
            timerLabel.text = "Time: \(timerValue)"
        }
    }
    
    override init(size: CGSize) {
      let maxAspectRatio:CGFloat = 9.0 / 15.0
      let playableHeight = size.width / maxAspectRatio
      let playableMargin = (size.height-playableHeight) / 2.0
    playableRect = CGRect(x: 0, y: playableMargin,
                            width: size.width,
                            height: playableHeight)
      super.init(size: size)
    }
    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        startButton.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        startButton.zPosition = 20
        startButton.name = "startGame"
        
        bg.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        bg.zPosition = -1
        self.addChild(bg)
        self.addChild(startButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchesNode = self.nodes(at: location)
            for node in touchesNode {
                if node.name == "circle" {
                    score += 1
                    randomCirclePosition()
                    gameOver()
                    print(score)
                }
                
                if node.name == "startGame" {
                    startButton.isHidden = true
                    circle.size.height = 64
                    circle.size.width = 64
                    circle.position = randomCirclePosition()
                    circle.name = "circle"
                    self.addChild(circle)
                    
                    timerLabel.fontColor = SKColor.white
                    timerLabel.fontSize = 40
                    timerLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 600)
                    self.addChild(timerLabel)

                    run(SKAction.repeatForever(SKAction.sequence([
                        SKAction.run {
                            self.timerValue += 1
                        } ,
                        SKAction.wait(forDuration: 1)
                    ])))
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        boundsCheckCircle()
    }
    
    func gameOver() {
        if score == 10 {
            if timerValue <= 7 {
                appDelegate.isWin = true
                NotificationCenter.default.post(name: kWinNotification, object: nil)
                print("You WIN!!!🥳")
            } else {
                appDelegate.isWin = false
                NotificationCenter.default.post(name: kWinNotification, object: nil)
                print("You LOSE!!!📛")
            }
        }
    }
    
    func randomCirclePosition() -> CGPoint {
        circle.position = CGPoint(
            x: CGFloat.random(
                min: playableRect.minX,
                max: playableRect.maxX),
            y: CGFloat.random(
                min: playableRect.minY,
                max: playableRect.maxY))
        return circle.position
    }
    
    func boundsCheckCircle() {
      let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
      if circle.position.x <= bottomLeft.x {
        circle.position.x = bottomLeft.x
        velocity.x = -velocity.x
      }
      if circle.position.x >= topRight.x {
        circle.position.x = topRight.x
        velocity.x = -velocity.x
      }
      if circle.position.y <= bottomLeft.y {
        circle.position.y = bottomLeft.y
        velocity.y = -velocity.y
      }
      if circle.position.y >= topRight.y {
        circle.position.y = topRight.y
        velocity.y = -velocity.y
      }
    }

}

