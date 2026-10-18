// you can move this to where u want it


int getWinner(table){
  int one_count = 0;
  int two_count = 0;
  for(int i = 0; i < 64; i++){
    if (table[i] == 1){
      one_count += 1;
    }
    else if (table[i] == 2){
      two_count += 1;
    }
  }
  if (one_count > two_count){
    return 1;
  }
  else if (two_count > one_count){
    return 2;
  }
  else{
    return 0;
  }
    
}
