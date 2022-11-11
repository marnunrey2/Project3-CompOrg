/************************
 
 File heading left blank

************************/

#include <iostream>  // Not needed in MIPS
using namespace std; // Not needed in MIPS

int drawTop(int numLines, int currLine){ 

    if(currLine == numLines){
        return 0;
    }
        
    int i = 0;
    while(i <= currLine){
        cout << "*"; 
        i++;
    }
    
    cout << endl;

    return i + drawTop(numLines, currLine + 1);
}

int drawBottom(int numLines, int currLine){ 

    if(currLine == numLines){
        return 0;
    }
        
    int i = 0;
    while(i < numLines - currLine){
        cout << "*"; 
        i++;
    }
    
    cout << endl;

    return i + drawBottom(numLines, currLine + 1);
}

int fixNegative(int toFix){

    return toFix * -1;
}

int main(){

    cout << "Enter the number of lines: ";
    int linesIn;
    cin >> linesIn;
    
    if(linesIn < 0){
        linesIn = fixNegative(linesIn);
    }

    int numOfStars = drawTop(linesIn, 0);
    numOfStars = numOfStars + drawBottom(linesIn, 0);

    cout << "Total Stars: " << numOfStars << endl;;
    return 0;

}


