//
//  TextArea.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/10.
//

import SwiftUI

struct TextArea: View {
    private let placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String = "Type something here...", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextEditor(text: $text)
            .foregroundColor(self.text == self.placeholder ? Color(UIColor.placeholderText) : .primary)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.screenHeight/5)
            .lineSpacing(1)
            .onAppear {
                self.text = self.placeholder
                // remove the placeholder text when keyboard appears
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                    withAnimation {
                        if (self.text == self.placeholder) {
                            self.text = ""
                        }
                    }
                }
                // put back the placeholder text if the user dismisses the keyboard without adding any text
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    withAnimation {
                        if (self.text == "") {
                            self.text = self.placeholder
                        }
                    }
                }
            }
    }
}

struct TextArea_Previews_Container: View {
    @State private var text = ""
    
    var body: some View {
        TextArea(text: $text)
    }
}

struct TextArea_Previews: PreviewProvider {
    static var previews: some View {
        TextArea_Previews_Container()
    }
}
