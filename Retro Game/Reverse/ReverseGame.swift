//
//  SwiftUIView.swift
//  Retro Game
//
//  Created by 平井悠貴 on 2024/03/03.
//

import SwiftUI

struct XY: Hashable {
    var x: Int
    var y: Int

    init(x: Int = 1, y: Int = 1) {
        self.x = x
        self.y = y
    }
}



struct ReverseGame: View {
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    // 0:黒 1:白
    @State var OthelloBoard =
        [[-1, -1, -1, -1, -1, -1, -1, -1],
         [-1, -1, -1, -1, -1, -1, -1, -1],
         [-1, -1, -1, -1, -1, -1, -1, -1],
         [-1, -1, -1,  1,  0, -1, -1, -1],
         [-1, -1, -1,  0,  1, -1, -1, -1],
         [-1, -1, -1, -1, -1, -1, -1, -1],
         [-1, -1, -1, -1, -1, -1, -1, -1],
         [-1, -1, -1, -1, -1, -1, -1, -1]];
    //オセロの順番
    @State var OthelloOrder = 0
    @State var OthelloPlace = [XY: [XY]]()
    @State var GameFinish = false;
    @State var Winner = 0;
    @Environment(\.presentationMode) var presentation
    @State private var gameResetToken = UUID()
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                ForEach(0..<8) { i in
                    HStack(spacing: 0) {
                        ForEach(0..<8) { j in
                            Button {
                                print(i,j)
                                if(OthelloPlace.keys.contains(XY(x: i, y: j))) {
                                    let ar = OthelloPlace[XY(x: i, y: j)]!
                                    for z in ar {
                                        OthelloBoard[i][j] = (OthelloOrder + 1) % 2
                                        OthelloBoard[z.x][z.y] = (OthelloOrder + 1) % 2
                                    }
                                    OthelloPlace = FindOthelloPiece(OthelloBoard: OthelloBoard, OthelloOrder: OthelloOrder)
                                    OthelloOrder = (OthelloOrder + 1) % 2;
                                    if(OthelloPlace.count == 0) {
                                        OthelloPlace = FindOthelloPiece(OthelloBoard: OthelloBoard, OthelloOrder: OthelloOrder)
                                        OthelloOrder = (OthelloOrder + 1) % 2;
                                        if(OthelloPlace.count == 0) {
                                            Winner = WhereWinner(OthelloBoard: OthelloBoard)
                                            GameFinish = true
                                        }
                                    }
                                }
                                
                            }label: {
                                ZStack {
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 0.5)
                                        .frame(width: (deviceWidth - 20) / 8, height: (deviceWidth - 20) / 8)
                                    if(OthelloBoard[i][j] == 1) {
                                        Text("◯")
                                            .foregroundColor(Color.black)
                                    }else if(OthelloBoard[i][j] == 0 ) {
                                        Text("●")
                                            .foregroundColor(Color.black)
                                    }else if(OthelloPlace.keys.contains(XY(x: i, y: j))) {
                                        Text("x")
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                
                
            }
            .alert("GameSet", isPresented: $GameFinish) {
                        // ダイアログ内で行うアクション処理...
                Button("スタートに戻る") {
                    self.presentation.wrappedValue.dismiss()
                }
            } message: {
                        // アラートのメッセージ...
                if(Winner == 0) {
                    Text("黒の勝ちです")
                }else {
                    Text("白の勝ちです")
                }
                        
            }
            if(OthelloOrder == 0) {
                Text("白のターンです")
                    .position(x:80,y:((deviceHeight / 2) + ((deviceWidth - 20) / 2)) + 10)
            }else {
                Text("黒のターンです")
                    .position(x:80,y:((deviceHeight / 2) + ((deviceWidth - 20) / 2)) + 10)
                    
            }
            
        }
        .onAppear {
            OthelloPlace = FindOthelloPiece(OthelloBoard: OthelloBoard, OthelloOrder: OthelloOrder)
            OthelloOrder += 1;
        }
    }
    //次のコマが置けるところを探す関数
    
}

#Preview {
    ReverseGame()
}
