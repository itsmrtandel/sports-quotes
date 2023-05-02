//
//  ViewController.swift
//  Sports Quotes
//
//  Created by Amit Tandel on 5/1/23.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    let productID = "App-Product-ID-from-Developer-Account"
    
    var nflQuotes = [
        "It’s not whether you get knocked down. It’s whether you get up. - Vince Lombardi",
        "Success isn’t owned, it’s leased. And rent is due every day. - J.J. Watt",
        "Wins and losses come a dime a dozen. But effort? Nobody can judge that. Because effort is between you and you. - Ray Lewis",
        "When you’re good at something, you’ll tell everyone. When you’re great at something, they’ll tell you. - Walter Payton",
        "You cannot make progress with excuses. - Cam Newton",
        "It's not the SIZE of the dog in the fight, but the size of the FIGHT in the dog. - Archie Griffin"
    ]
    
    let nbaQuotes = [
        "Never say never, because limits, like fears, are often just an illusion. - Michael Jordan",
        "The time when there is no one there to feel sorry for you or to cheer for you is when a player is made. - Tim Duncan",
        "If you do the work you get rewarded. There are no shortcuts in life. - Michael Jordan",
        "Be led by your dreams not by your problems. - Roy Williams",
        "Ask not what your teammates can do for you. Ask what you can do for your teammates. - Magic Johnson",
        "Success is not an accident, success is actually a choice. - Stephen Curry"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)
        
        if isPurchased() == true {
            showPremiumQuotes()
        }

    }

    // MARK: - Table view data source
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return nflQuotes.count
        } else {
            return nflQuotes.count + 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        if indexPath.row < nflQuotes.count {
            cell.textLabel?.text = nflQuotes[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get NBA Quotes"
            cell.textLabel?.textColor = UIColor.systemBlue
            cell.accessoryType = .disclosureIndicator
        }
            
        return cell
    }

    //MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == nflQuotes.count {
            buyPremiumQuotes()
        }
    //MARK: - In-App Purchase Methods
        
        func buyPremiumQuotes() {
            if SKPaymentQueue.canMakePayments() {
                //can make payments
                let paymentRequest = SKMutablePayment()
                paymentRequest.productIdentifier = productID
                SKPaymentQueue.default().add(paymentRequest)
                
            } else {
                //cant make payments
                print("user can't make payments")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //user payment successful
                print("transaction successful")
                showPremiumQuotes()
                                
                SKPaymentQueue.default().finishTransaction(transaction)
                
                
            } else if transaction.transactionState == .failed {
                //payment failed
                print("transaction failed")
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("transaction failed due to \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .restored {
            
                showPremiumQuotes()
                
                print("transaction restored")
                
                navigationItem.setRightBarButton(nil, animated: true)
                
                SKPaymentQueue.default().finishTransaction(transaction)

                
            }
        }
    }
    
    func showPremiumQuotes() {
        
        UserDefaults.standard.set(true, forKey: productID)

        nflQuotes.append(contentsOf: nbaQuotes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus == true {
            print("previously purchased")
            
            return true
        } else {
            print("never purchased")
            return false
        }
    }
    
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }


}
