//
//  EvolutionTree.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 09/03/22.
//

import Foundation

class PokemonEvolutionTree {
    
    private var root: Node<PokemonShort>
    private var helperDictionary = [String:Node<PokemonShort>]()
    
    init(root: Node<PokemonShort>){
        self.root = root
    }
    
    init(chain: EvolutionChainAPI) {
        
        self.root = Node<PokemonShort>(value: PokemonShort(name: chain.chain.species.name, url: PokemonEvolutionTree.getUrlForSpecie(specieUrl: chain.chain.species.url)))
        self.helperDictionary[chain.chain.species.name] = self.root
        recursiveTreeAdd(chain: chain.chain, node: root)
    }
    
    private static func getUrlForSpecie(specieUrl: String) -> String {
        
        let id = specieUrl.split(separator: "/").last ?? "1"
        return "https://pokeapi.co/api/v2/pokemon/" + id
        
    }
    
    private func recursiveTreeAdd(chain: EvolutionApi, node: Node<PokemonShort>) {
        
        for specie in chain.evolves_to {
            
            let newNode = Node<PokemonShort>(value: PokemonShort(name: specie.species.name, url: PokemonEvolutionTree.getUrlForSpecie(specieUrl: specie.species.url)))
            
            node.addChild(child: newNode)
            self.helperDictionary[specie.species.name] = newNode
            
            recursiveTreeAdd(chain: specie, node: newNode)
        }
        
    }
    
    public func getPreviousEvolutions(from name: String) -> [PokemonShort] {
        guard let node = helperDictionary[name] else { return []}
        
        var toRet = [PokemonShort]()
        
        var current = node
        
        while let parent = current.parent {
            toRet.append(parent.value)
            current = parent
        }
        return toRet
    }
    
    public func getNextEvolutions(from name: String) -> [PokemonShort] {
        guard let node = helperDictionary[name] else { return []}
        
        let toRet = visitTreeFromNode(node: node, array: [], shouldAppend: false)
        return toRet.sorted(by: {(Int($0.id) ?? 0) < (Int($1.id) ?? 0)})
    }
    
    private func visitTreeFromNode(node: Node<PokemonShort>, array: [PokemonShort], shouldAppend: Bool = true) -> [PokemonShort] {
        
        var new = array
        if shouldAppend {
            new.append(node.value)
        }
        
        for child in node.children {
            new = visitTreeFromNode(node: child, array: new)
        }
        return new
    }
    
    //Expensive, used helper dictionary instead
    private func getNode(with name: String, currentNode: Node<PokemonShort>) -> Node<PokemonShort>? {
        
        if currentNode.value.name == name {
            return currentNode
        }
        
        for node in currentNode.children {
            
            let retNode = getNode(with: name, currentNode: node)
            
            if retNode != nil {
                return retNode
            }
            
        }

        return nil
    }
    
}


class Node<T> {
    
    var value: T
    var children: [Node] = []
    weak var parent: Node?
    
    init(value: T){
        self.value = value
    }
    
    func addChild(child: Node<T>){
        self.children.append(child)
        child.parent = self
    }
    
}
