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
    // const
    "const_int",
    "const_real",
    "const_string",
    "const_bool",
    "const_array",
    // function
    "function"};

enum dataType
{
    type_error = -1,
    type_int,
    type_real,
    type_string,
    type_bool,
    type_array,
    // const
    type_const_int,
    type_const_real,
    type_const_string,
    type_const_bool,
    type_const_array,
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
        return type_const_int;
    case 6:
        return type_const_real;
    case 7:
        return type_const_string;
    case 8:
        return type_const_bool;
    case 9:
        return type_const_array;
    case 10:
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
    void insert(const string, const dataType, const string);
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

void symbolTable::insert(const string symbol, const dataType _type, const string value)
{
    if (lookup(symbol) != 0)
    {
        printf("ERROR:symbol already define\n");
    }

    table[symbol].type = _type;
    if (_type == type_const_string || _type == type_string)
    {
        table[symbol].stringVal = value;
        return;
    }
    if (_type == type_const_bool || _type == type_bool)
    {
        table[symbol].realVal = value == "true" ? 1 : 0;
        return;
    }
    if (value == "")
    {
        table[symbol].realVal = 0;
        return;
    }
    if (_type == type_array)
    {
        table[symbol].stringVal = value;
        return;
    }
    table[symbol].realVal = stoi(value);
}

void symbolTable::dump()
{
    int width = 20;
    cout << "==============================" << endl;
    cout << "Symbol Table:" << endl;
    cout << "ID"
         << "\t\t"
         << "type"
         << "\t\t"
         << "value" << endl;
    for (auto &a : table)
    {
        cout << a.first << "\t\t" << typeString[a.second.type] << "\t\t";
        if (a.second.type == type_const_string || a.second.type == type_string)
        {
            cout << a.second.stringVal << endl;
        }
        else
        {
            cout << a.second.realVal << endl;
        }
    }
}

dataType symbolTable::getType(const string &symbol, bool isConst)
{
    if (isConst)
    {
        if (symbol[0] == '\"')
            return type_const_string;
        if (symbol.find('.') != -1)
            return type_const_real;
        if (isNumeric(symbol))
            return type_const_int;
        if (symbol == "true" || symbol == "false")
            return type_const_bool;
    }
    else
    {
        if (symbol[0] == '\"')
            return type_string;
        if (symbol.find('.') != -1)
            return type_real;
        if (isNumeric(symbol))
            return type_int;
        if (symbol == "true" || symbol == "false")
            return type_bool;
    }
    return table[symbol].type;
}

#endif