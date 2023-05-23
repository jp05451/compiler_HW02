#ifndef SYMBOLTABLE_HPP
#define SYMBOLTABLE_HPP
#include <vector>
#include <set>
#include <string>
#include <unordered_map>
#include <algorithm>
#include <iostream>
#include <iomanip>
#include <stack>

#define MAX_LINE_LENG 256

using namespace std;

string typeString[] = {
    "int",
    "real",
    "string",
    "bool",
    "array",
    // function
    "function"};

enum dataType
{
    type_null = -1,
    type_int,
    type_real,
    type_string,
    type_bool,
    type_array,
    // funcion
    type_function

};

dataType intToType(int number)
{
    switch (number)
    {
    case 0:
        return type_int;
    case 1:
        return type_real;
    case 2:
        return type_string;
    case 3:
        return type_bool;
    case 4:
        return type_array;
    case 5:
        return type_function;
    }
}

bool isNumeric(std::string const &str)
{
    auto it = str.begin();
    while (it != str.end() && std::isdigit(*it))
    {
        it++;
    }
    return !str.empty() && it == str.end();
}

class functionData
{
public:
    int varNumber=0;
    dataType returnType;
};

class symbolData
{
public:
    dataType type;
    bool isConst;
    string stringVal;
    double realVal;
    functionData f_data;
};

class symbolTable
{
public:
    symbolTable()
    {
    }
    ~symbolTable() 
    {
        
    }
    void creat();
    // unordered_map<string, symbolData>::iterator &lookup(const string &symbol);
    bool lookup(const string &symbol);
    void insert(const string, const dataType,bool);
    void dump();
    dataType getType(const string &, bool);

    // private:
    // vector<vector<string>> table;
    unordered_map<string, symbolData> table;
    // unordered_map<int, set<string>> table;
};

void symbolTable::creat()
{
    // table.resize(1);
}

bool symbolTable::lookup(const string &symbol)
{
    unordered_map<string, symbolData>::iterator got = table.find(symbol);
    if (got == table.end())
        return 0;
    else
        return 1;
}

void symbolTable::insert(const string symbol, const dataType _type,bool _isConst)
{
    if(lookup(symbol)!=0)
    {
        cout << "symbolTable ERROR: ID redefine" << endl;
        return;
    }
    table[symbol].type = _type;
    table[symbol].isConst = _isConst;
    cout << symbol << " is inserted" << endl;
}

void symbolTable::dump()
{
    int width = 20;
    cout << "==============================" << endl;
    cout << "Symbol Table:" << endl;

    cout << "ID"
         << "\t\t"
         << "type" << endl;
    //  << "type" << endl;
    for (auto &a : table)
    {
        cout << a.first << "\t\t";
        a.second.isConst ? cout << "const " : cout << "";
        cout << typeString[a.second.type] << endl;
    }
}

dataType symbolTable::getType(const string &symbol, bool isConst)
{
    // if (isConst)
    // {
    //     if (symbol[0] == '\"')
    //         return type_const_string;
    //     if (symbol.find('.') != -1)
    //         return type_const_real;
    //     if (isNumeric(symbol))
    //         return type_const_int;
    //     if (symbol == "true" || symbol == "false")
    //         return type_const_bool;
    // }
    // else
    // {
    //     if (symbol[0] == '\"')
    //         return type_string;
    //     if (symbol.find('.') != -1)
    //         return type_real;
    //     if (isNumeric(symbol))
    //         return type_int;
    //     if (symbol == "true" || symbol == "false")
    //         return type_bool;
    // }
    // return table[symbol].type;
}

#endif