#include <vector>
#include <set>
#include <string>
#include <unordered_map>
#include <algorithm>
#include <iostream>

using namespace std;

enum symbolType
{
    TYPE,VALUE
};

class symbolTable
{
public:
    symbolTable()
    {
        // table.resize(1);
    }
    ~symbolTable() {}
    void creat();
    int lookup(const string &symbol);
    void insert(const string &symbol,const string&,const string&);
    void dump();

private:
    // vector<vector<string>> table;
    unordered_map<string, vector<string>> table;
    // unordered_map<int, set<string>> table;
};

void symbolTable::creat()
{
    // table.resize(1);
}

int symbolTable::lookup(const string &symbol)
{

    unordered_map<string, vector<string>>::const_iterator got = table.find(symbol);
    if(got==table.end())
        return 0;
    else
        return 1;
}

void symbolTable::insert(const string &symbol,const string &type="",const string &value="")
{
    table[symbol][VALUE] = value;
    table[symbol][TYPE] = type;
    cout << symbol << " is inserted" << endl;
}

void symbolTable::dump()
{
    cout << "Symbol Table:" << endl;
    // cout << "ID" << endl;
    for (auto &a : table)
    {
        cout << a.second[TYPE]<<"\t"<<a.second[VALUE] << endl;
    }
}