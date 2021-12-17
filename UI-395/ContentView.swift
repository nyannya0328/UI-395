//
//  ContentView.swift
//  UI-395
//
//  Created by nyannyan0328 on 2021/12/17.
//

import SwiftUI

struct ContentView: View {
    @StateObject var moldel = sampleModel()
    
    let columns = Array(repeating: GridItem(.flexible(),spacing: 10), count: 3)
    var body: some View {
        NavigationView{
            
            
            ScrollView{
                
                
                LazyVGrid(columns: columns) {
                    
                    
                    
                    ForEach(moldel.fetechedImages){image in
                        
                        
                        
                        NavigationLink {
                            
                            Text(image.author)
                                .navigationTitle(image.author)
                            
                            
                        } label: {
                            
                            GeometryReader{proxy in
                                
                                
                                let size = proxy.size
                                
                                
                                AsyncImage(url: URL(string: image.download_url), content: { IMAGE in
                                    
                                    
                                    IMAGE
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: size.width, height: size.height)
                                        .cornerRadius(10)
                                    
                                }, placeholder: {
                                    
                                    
                                    ProgressView()
                                })
                                    .frame(width: size.width, height: size.height)
                                   
                                
                                
                                
                                
                                
                                
                            }
                            .frame(height: 150)
                            
                            
                            
                            
                        }

                        
                        
                        
                    }
                    
                    
                    
                }
                .padding()
                
                
                
            }
            .navigationTitle("Aync Images")
            
            
            
        }
        .task {
            do{
                
                moldel.fetechedImages = try await moldel.fetchedImage()
        
                
            }
            catch{
                
                print(error.localizedDescription)
                
              
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class sampleModel : ObservableObject{
    
    @Published var fetechedImages : [ImageModel] = []
    
    func fetchedImage() async throws -> [ImageModel]{
        
        guard let url = URL(string: "https://picsum.photos/v2/list") else{
            
            
          throw ImageError.failed
        }
        
        let (data,_) = try await URLSession.shared.data(from: url)
        
        
        let json = try JSONDecoder().decode([ImageModel].self, from: data)
        
        return json
        
        
        
        
    }
    
    
}

enum ImageError : Error{
    
    case failed
}

struct ImageModel :Identifiable,Codable{
    
    var id : Int
    var author : String
    var download_url : String
    
    
    enum Coodingkeys : String,CodingKey{


        case id
        case author
        case download_url

    }
}
