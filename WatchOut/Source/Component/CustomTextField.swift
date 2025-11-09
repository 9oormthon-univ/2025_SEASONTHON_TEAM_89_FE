//
//  CustomTextField.swift
//  WatchOut
//
//  Created by 어재선 on 9/5/25.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let enter: () -> Void
    var isDisabled: Bool
    var body: some View {
        
        VStack {
           
            HStack{
                ZStack {
                    if text.isEmpty {
                        HStack{
                            Text("여기 문장을 입력해 보세요")
                                .font(.pBody01)
                                .foregroundStyle(.black.opacity(0.5))
                                .padding(8)
                            Spacer()
                        }
                        
                    }
                    TextField("" ,text: $text)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20))
                        .padding(8)
                        .accentColor(.gray)
                        .onSubmit {
                            enter()
                        }
                }
                
                
                Button{
                    enter()
                } label: {
                    ZStack {
                        Circle()
                            .scaledToFit()
                            .frame(width: 36)
                            .foregroundStyle(.main)
                        Image("uparrow")
                            
                        
                    }
                    
                        
                }
                .padding(.leading, 8)
                .disabled(isDisabled)
            }
            
            .padding(.horizontal)
            .padding(.vertical,4)
        }
        .background(.textfieldbackground.opacity(0.08))
        .cornerRadius(87)
        .overlay{
            RoundedRectangle(cornerRadius: 87)
                .stroke(.main,lineWidth: 1)
        }
        
    }
}

#Preview {
    CustomTextField(text: .constant(""), enter: {}, isDisabled: false)
}
