//
//  ContentView.swift
//  CaculatorMobile
//
//  Created by StudentAM on 3/1/24.
//



import SwiftUI

struct ContentView: View {
    // State variables to manage the calculator display and operation
    @State private var display = "0"
    @State private var currentNumber = ""
    @State private var previousNumber = ""
    @State private var operation = ""
    
    // Define the layout of buttons on the calculator
    let buttons: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]

    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 12) {
                // Display area for the calculator
                HStack {
                    Spacer() // Pushes the Text view to the right
                    Text(display)
                        .font(display.count > 6 ? .system(size: 74 - CGFloat(display.count - 6) * 4) : .system(size: 94))
                        .padding()
                        .foregroundColor(.white)
                }
                
                // Buttons layout
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.handleButtonPress(button)
                            }) {
                                Text(button)
                                    .font(.system(size: 32))
                                    .foregroundColor(buttonTextColor(for: button))
                                    .frame(width: buttonWidth(for: button), height: 80)
                                    .background(self.buttonColor(for: button))
                                    .cornerRadius(40)
                                    .padding(.leading, leadingPadding(for: button))
                            }
                            .padding(.horizontal, button == "0" ? 19 : 0) // Add padding to zero button
                        }
                    }
                }
            }
            .padding()
            .background(Color.black)
        }
    }

    // Function to handle button presses
    private func handleButtonPress(_ button: String) {
        guard currentNumber.count < 9 || button == "AC" else { return }
        switch button {
        case "AC":
            // Clear the calculator
            display = "0"
            currentNumber = ""
            previousNumber = ""
            operation = ""
        case "+/-":
            // Toggle sign of the current number
            if !currentNumber.isEmpty {
                if currentNumber.first == "-" {
                    currentNumber.removeFirst()
                } else {
                    currentNumber = "-" + currentNumber
                }
                display = currentNumber
            }
            break
        case "%":
            // Calculate percentage of the current number
            if let num = Double(currentNumber) {
                display = String(num / 100)
                currentNumber = display
            }
            break
        case "0"..."9":
            // Append digits to the current number
            if display == "0" {
                currentNumber = button
            } else if currentNumber.count < 9 {
                currentNumber += button
            }
            display = formatDisplay(currentNumber)
        case ".":
            // Append decimal point to the current number
            if !currentNumber.contains(".") {
                currentNumber += button
                display = formatDisplay(currentNumber)
            }
            break
        case "÷", "×", "-", "+":
            // Store previous number and selected operation
            previousNumber = currentNumber
            currentNumber = ""
            operation = button
            display = "0"
        case "=":
            // Perform the calculation and display the result
            if let previous = Double(previousNumber), let current = Double(currentNumber) {
                switch operation {
                case "+":
                    display = formatDisplay(String(previous + current))
                case "-":
                    display = formatDisplay(String(previous - current))
                case "×":
                    display = formatDisplay(String(previous * current))
                case "÷":
                    display = formatDisplay(String(previous / current))
                default:
                    break
                }
            }
        default:
            break
        }
    }

    // Format the display of the result
    private func formatDisplay(_ result: String) -> String {
        if let number = Double(result) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 8 // Set the maximum number of fractional digits
            
            if let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) {
                return formattedNumber
            } else {
                return result
            }
        } else {
            return result
        }
    }
    
    // Define the width of each button
    private func buttonWidth(for button: String) -> CGFloat {
        switch button {
        case "0":
            return 180 // Width for zero button
        default:
            return 80 // Width for other buttons
        }
    }

    // Define the leading padding for each button
    private func leadingPadding(for button: String) -> CGFloat {
        switch button {
        case "AC", "+/-", "%", "÷":
            return 7 // No leading padding for buttons in the left column
        case "0" :
            return -2 // Adjusted leading padding for zero button
        case "." :
            return -15  // Adjusted leading padding for decimal button
        default:
            return 8 // Default leading padding for other buttons
        }
    }
    
    // Determines the background color of the buttons based on the button type and operation state
    private func buttonColor(for button: String) -> Color {
        switch button {
        case "/", "×", "-", "+", "=", "÷":
            return operation == button ? Color.white : Color.orange
        case "AC", "+/-", "%" :
            return .customLightGray
        default:
            return .customDarkGray
        }
    }

    
    // Determines the text color of the buttons based on the button type
    private func buttonTextColor(for button: String) -> Color {
        switch button {
        case "AC", "+/-", "%" :
            return .black
        default:
            return .white
        }
    }

    // Calculates the font size for the display text based on the number of digits
private func fontSize(for number: String) -> CGFloat {
        if number.count > 6 {
            return 64 - CGFloat(number.count - 6) * 4
        } else {
            return 64
        }
    }
}

// custom colors for the buttons on the caculator
extension Color {
    static let customDarkGray = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let customLightGray = Color(red: 0.7, green: 0.7, blue: 0.7)
}




#Preview{
    ContentView()
}
