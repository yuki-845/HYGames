//
//  OnlineReversiRoom.swift
//  Retro Game
//
//  Created by 平井悠貴 on 2024/03/11.
//

import SwiftUI
import FirebaseFirestore
struct OnlineReversiRoom: View {
    @ObservedObject private var viewModel = ViewModel()
    @AppStorage("UserName") var UserName = ""
    @Binding var isRoomView: Bool
    @State var db = Firestore.firestore()
    var body: some View {
        ZStack {
            VStack {
                Text("\(viewModel.text)これからの人生")
                Text("オンライン対戦")
                    .font(.largeTitle)
                
                Button {
                    db.collection("EmptyRoom").document(UserName).setData(["isEnterRoom": false])
                    
                }label: {
                    Text("部屋を作る")
                }
                Text("部屋に入る")
                HStack {
                    ForEach(viewModel.emptyroomdata, id: \.self) { data in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.blue)
                                .frame(width: 50,height: 50)
                            Text(data.UserName)
                            
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
