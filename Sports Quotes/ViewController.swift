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
        "Winning isn't everything, but wanting to win is. - Vince Lombardi",
        "Success isn’t owned, it’s leased. And rent is due every day. - J.J. Watt",
        "Wins and losses come a dime a dozen. But effort? Nobody can judge that. Because effort is between you and you. - Ray Lewis",
        "When you’re good at something, you’ll tell everyone. When you’re great at something, they’ll tell you. - Walter Payton",
        "You cannot make progress with excuses. - Cam Newton",
        "It's not the SIZE of the dog in the fight, but the size of the FIGHT in the dog. - Archie Griffin"
    ]
    
    let nbaQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
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
