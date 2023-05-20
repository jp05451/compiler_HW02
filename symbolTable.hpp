#ifndef SYMBOLTABLE_HPP
#define SYMBOLTABLE_HPP
#include <vector>
#include <set>
#include <string>
#include <unordered_map>
#include <algorithm>
#include <iostream>

#define MAX_LINE_LENG 256

using namespace std;

enum dataType
{
    type_int,
    type_real,
    type_string,
    type_bool,
    type_array,
    type_function
};

enum dataValue
{
    COSTANT,
    DATA_TYPE,
    IDENTITY
};

typedef struct symbolData
{
    int type;
    char stringVal[256];
    double realVal;
    char identity[256];
} symbolData;

class symbolTable
{
public:
    symbolTable()
    {
    }
    ~symbolTable() {}
    void creat();
    int lookup(const string &symbol);
    void insert(const string &symbol, const dataType &, const string &);
    void dump();

private:
    // vector<vector<string>> table;
    unordered_map<string, symbolData> table;
    // unordered_map<int, set<string>> table;
};

void symbolTable::creat()
{
    // table.resize(1);
}

int symbolTable::lookup(const string &symbol)
{
    unordered_map<string, symbolData>::const_iterator got = table.find(symbol);
    if (got == table.end())
        return 0;
    else
        return 1;
}

void symbolTable::insert(const string &symbol, const dataType &type, const string &value = "")
{
    // table[symbol].data = value;
    // table[symbol].type = type;
    // cout << symbol << " is inserted" << endl;
}

void symbolTable::dump()
{
    cout << "Symbol Table:" << endl;
    // cout << "ID" << endl;
    // for (auto &a : table)
    // {
    //     cout << a.second[TYPE]<<"\t"<<a.second[VALUE] << endl;
    // }
}

#endif