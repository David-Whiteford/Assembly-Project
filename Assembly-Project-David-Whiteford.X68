*-----------------------------------------------------------
* Title      :ZorkQuest Battle for Themaron
* Written by : David Whiteford
* Date       : 8/4/18
* Description: text game with castle attack missions and resourse management. mission is to take the two castles.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

  org $1000

*-------------------------------------------------------
*-------------------------------------------------------

*-------------------------------------------------------
*Validation values to be used, modify as needed
*Add additional validation values as required
*-------------------------------------------------------
exit        EQU 0      used to exit assembly program
min_feed    EQU 100    min feed requirement
min_horses  EQU 1      min number of horses
max_horses  EQU 9      max number of horses
min_soldier EQU 6      min soldiers
min_charge  EQU 1      min rate of fuel use based of speed (oats for horses)
max_charge  EQU 5      max rate e.g. Flank       
hit_point   EQU 5      points accumilated on castle (objective) strike
miss_point  EQU 8      points deducted for ordinace miss

mine_loc    EQU 100    example for a hit


*Start of Game
start:
    move.b  #100,$4000 put score/health in memory location $4000
    lea     $4000,A3   assign address A3 to that memory location


    bsr     welcome    branch to the welcome subroutine
    bsr     game       branch to the game subroutine
*Game loop
    org     $3000     the rest of the program is to be located from 3000 onwards

*-------------------------------------------------------
*-------------------Game Subroutine---------------------
*-------------------------------------------------------
game:
    bsr     gameloop   branch to gameloop subroutine
    rts                return from game: subroutine
          
end:
    simhalt

*-------------------------------------------------------
*-------------------Welcome Subroutine------------------
*-------------------------------------------------------
welcome:

    move.l #200 , $15000              stores feed cost in memory 5000
    move.l #2000 , $16000             stores feed in memory 6000
    move.b #6 , $17000                stores horses in 7000
    move.b #8 , $18000                stores soliders in 8000
    move.l #1500, $10000             stores gold in 10000
    move.l #100 , $12000             stores solider cost in 12000
   
    lea     welcome_msg,A1         assign message to address register A1
    move.b  #14,D0                 move literal 14 to DO
    trap    #15                    interpt val in Do
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15
    lea     start_msg,A1           assign message to address register A1
    move.b  #14,D0                 move literal 14 to DO
    trap    #15                    interpt val in Do
    move.l   #150,D1               move 150 to d1
    move.b   #23,D0                trap 23  timer
    trap   #15                     trap 15 
    lea    intro_msg , A1          assign message to address register A1
    move.b #14 , D0          trap 14 output msg
    trap #15                 trap 15 interpt D0
    move.l #150,D1     
    move.b #23,D0               trap 23 
    trap   #15 

    bra mission1_prep         branch to mission 1 prep


              

utine
    rts                     return from welcome: subroutine

*-------------------------------------------------------
*---------Gameplay Input Values Subroutine--------------
*-------------------------------------------------------    


*-------------------------------------------------------
*----------------Gameloop (main loop)-------------------
*------------------------------------------------------- 
gameloop:
    bsr     update          branch to update game subroutine 
    bsr     clear_screen    clears the screen         
    bsr     draw            branch to draw screen subroutine
    bsr     clear_screen    clears the screen
    bsr     gameplay        branch to gameplay subroutine
    bsr     clear_screen    clears the screen
    bsr     hud             branch to display HUD subroutine
    bsr     clear_screen    clears the screen
    bsr     replay          branch to replay game subroutine
    bsr     clear_screen    clears the screen
    rts                     return from gameloop: subroutine
    
*-------------------------------------------------------
*----------------shop and info------------------
*------------------------------------------------------- 
Shop_and_info:


    
    lea shop_msg ,A1     stores shop message A1
    move.b #14 , D0      store 14 D0 
    trap #15             interpet D0
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1       
    beq feed_amount       branch if equal
    cmp #2 , D1          compare 2 to d1
    beq horses_amount    branch if equal
    cmp #3 , D1          compare 3 to d1
    beq soliders_amount   branch if equal
    cmp #4 , D1          compare 4 to d1
    beq buy_stuff         branch if equal
*-------------------------------------------------------
*----------------buy stuff ------------------
*-------------------------------------------------------    

 buy_stuff:
    lea buy_suff_msg , A1     assign message to address register A1
    move #14 , D0             trap 14 output msg
    trap #15                    
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 
    beq buy_feed          branch if equal
    cmp #2 , D1          compare 1 to d1   
    beq buy_horses       branch if equal
    cmp #3 , D1          compare 1 to d1 
    beq buy_soliders     branch if equal
    cmp #4 , D1         compare 1 to d1 
    beq mission1_prep    branch if equal
*-------------------------------------------------------
*----------------feed amount------------------
*------------------------------------------------------- 
feed_amount:    

    move.l $16000 , D1
    lea feed_amount_msg , A1          assign message to address register A1
    move #17 , D0                     trap 17 outputs val in d0
    trap #15                         trap 15 interpt D0
    move.l   #150,D1     
    move.b   #23,D0                  trap 23 timer
    trap #15             trap 15 interpt D0
    bra Shop_and_info      branch shop and info
 *-------------------------------------------------------
*----------------soliders amount------------------
*------------------------------------------------------- 
soliders_amount:



    move.b $18000 , D1
    lea soliders_amount_msg , A1  assign message to address register A1
    move #17 , D0        trap 17 output val d0
    trap #15             trap 15 interpt D0
    move.l   #150,D1     timer is 50 
    move.b   #23,D0      trap 23 for timer
    trap #15             trap 15 interpt D0

    bra Shop_and_info     branch shop and info
*-------------------------------------------------------
*----------------horses amount------------------
*------------------------------------------------------- 
horses_amount:

    move.b $17000 , D1
    lea horses_amount_msg , A1       assign message to address register A1
    move #17 , D0
    trap #15             trap 15 interpt D0
    move.l   #150,D1      150 timer
    move.b   #23,D0       trap 23 in d0
    trap #15             trap 15 interpt D0
    bra Shop_and_info     branch shop and info
*-------------------------------------------------------
*----------------Buy feed------------------
*-------------------------------------------------------     
buy_feed:
          
    lea Buy_feed_msg , A1  assign message to address register A1
    move.b #14 , D0          trap 14 output ms
    trap #15
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15                 trap 15 interpt D0  
    move.l $16000 , D1         move memory 6000 to d1
    move.l #200 , D3          move 200 to d3
    add D1 , D3              add d1 to d3
    move.l  D3 , $16000       move d3 memory  6000
    move.l $10000 , D1       move memory 10000 to d1
    move.l #200 , D3         move 200 to d3
    sub D1 , D3              sub d1 from d3
    move.l  D3 , $10000      move d3 to memory  10000
    bra Shop_and_info        branch shop and info
*-------------------------------------------------------
*----------------Buy soliders------------------
*------------------------------------------------------- 
buy_soliders:

    lea Buy_soliders_msg , A1    assign message to address register A1
    move.b #14 , D0          trap 14 output msg
    trap #15  
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15               trap 15 interpt D0  
    move.b $18000 , D1        move memory 8000 to d1
    move.l #2 , D3           move 2 to d3
    add D1 , D3              add d1 to d3
    move.l  D3 , $18000       move d3 to memory 8000
    move.l $10000 , D1       move memory 10000 to d1
    move.l #400 , D3         move 400 into d3
    sub D1 , D3              sub d1 from d3   
    move.l  D3 , $10000      move d3 to memory  10000
    bra Shop_and_info        branch shop and info
    
*-------------------------------------------------------
*----------------Buy horses------------------
*------------------------------------------------------- 
buy_horses: 

    lea Buy_horses_msg , A1     assign message to address register A1
    move.b #14 , D0          trap 14 output msg
    trap #15   
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15              trap 15 interpt D0 
    move.b $17000 , D1         move memory 7000 to d1
    move.l #2 , D3           move 2 d3
    add D1 , D3             add d1 to d3
    move.l  D3 , $17000       move d3 to 7000
    move.l $10000 , D1       move memory 10000 to d1
    move.l #300 , D3         move 300 to d3
    sub D1 , D3              sub d1 from d3
    move.l  D3 , $10000      move d3 to memory 10000
    bra Shop_and_info        branch shop and info
*-------------------------------------------------------
*----------------mission 1 preperation------------------
*------------------------------------------------------- 
mission1_prep:

    lea     Algard_Castle_msg , A1    assign message to address register A1
    move.b  #14,D0                    move literal 14 to DO
    trap #15             trap 15 interpt D0
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1         
    beq  feed             branch fees
    cmp #2 , D1           compare 2 to d1   
    beq horses             branch horses 
    cmp #3 , D1           compare 3 to d1   
    beq  soldiers         branch to soliders
    cmp #4 , D1           compare 4 to d1   
    beq goodwait          branch goodwait
    cmp #5 , D1           compare 5 to d1   
    beq badwait           branch goodwait
    cmp #6 , D1           compare 5 to d1
    beq Shop_and_info     branch goodwait
   

*-------------------------------------------------------
*----------------Invalid selection msg------------------
*-------------------------------------------------------  
invalid_selection:
        
        lea invalid_msg ,A1        assign message to address register A1
        move.b #14 , D0          trap 14 output msg
        trap #15                 trap 15 interpt D0
        move.l #150,D1     
        move.b #23,D0        trap 23 for timer
        trap #15             trap 15 interpt D0
        
        jmp mission1_prep
*-------------------------------------------------------
*----------------mission 2 preperation------------------
*------------------------------------------------------- 
   
mission2_prep:

    lea     Garth_Castle_msg , A1    assign message to address register A1
    move.b #14 , D0          trap 14 output msg
    trap #15                 trap 15 interpt D0                    
    move.l #500 , $15000               new cost values for gold and feed stores in 5000 and 12000
    move.l #400 , $12000
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 
    beq  feed_mission2
    move.b #6,$17000                  stores horses in 7000
    cmp #2 , D1
    beq horses_mission2
    move.b #8 , $18000              stores number of soliders 8000
    cmp #3 , D1
    beq  soldiers_mission2
    cmp #4 , D1                  user input and comparison with 4 
    beq goodwait2
    cmp #5 , D1
    beq badwait2
*-------------------------------------------------------
*----------------mission 1-----------------------------
*outputs battle message and brances to mission 1 cost and award
*------------------------------------------------------- 
mission1:

    lea battle_msg ,A1 assign message to address register A1
    move.b #14 , D0          trap 14 output msg
    trap #15                 trap 15 interpt D0
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 
    beq mission1_Cost_Awards
    
*-------------------------------------------------------
*----------------mission 2-----------------------------
*outputs battle message and brances to mission 2 cost and award
*------------------------------------------------------- 
mission2:

   lea battle_msg2 , A1
   move.b #14 , D0          trap 14 output msg
   trap #15                 trap 15 interpt D0

    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 
    beq mission2_Cost_Awards
   
*-------------------------------------------------------
*---------------Update Mission Progress-----------------
*  Move to battle location, engage enemy, fire and take
*  fire, complete mission and return to base
*------------------------------------------------------- 
update:
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop

    lea     battle_msg , A1       
    move.b #14 , D0          trap 14 output msg
    trap #15                 trap 15 interpt D0
    bsr     decorate
    rts
*-------------------------------------------------------
*---------------Draw Mission Updates--------------------
* Draw the game progress information, status regarding
* mission
*------------------------------------------------------- 
draw:
    bsr     endl
    bsr     decorate
    lea     draw_msg,A1
    move.b #14 , D0          trap 14 output msg
    trap #15                 trap 15 interpt D0
    bsr     decorate
    rts
*-------------------------------------------------------
*-----------------------Horse feed-----------------------
* Multiplies feed by no of horses to determine feed cost
*------------------------------------------------------- 
feed:
  
     move.l $16000 , D1
  
    lea     feed_amount_msg , A1 assign message to address register A1
    move #17 , D0                     trap 17 outputs val in d0
    trap #15                 trap 15 interpt D0
    
    move.l   #150,D1     
    move.b   #23,D0                  trap 23 timer
    trap #15
 
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 

    move.b $17000 , D1    move memory 7000 to d1
    move.l $16000, D2     move memory 6000 to d2
    move.l $15000 , D3    move memory 5000 to d3
    mulu D1 , D3         mul d1 by d3
    move.l D3 , $19000    move d3 to memory 9000
    cmp D2 , D3          compare d2 nd d3
    blt     plenty_feed  branch if less than
    cmp D2 , D3          compare d2 nd d3
    bgt not_enough_feed  branch if greather than
*-------------------------------------------------------
*------------not enough feed --------------------
* checks if there is not enough feed
*-------------------------------------------------------    
    
not_enough_feed:

        lea low_feed  ,A1    assign message to address register A1
        move.b #14 , D0          trap 14 output msg
        trap #15                 trap 15 interpt D0
        move.b #4 ,D0        trap 4 for user input
        trap #15             trap 15 interpt D0
        cmp #1 , D1          compare 1 to d1 
        beq  mission1_prep
*-------------------------------------------------------
*------------enough feed --------------------
*checks if there is enough feed
*-------------------------------------------------------           
        
        
plenty_feed:  

   
        lea enough_feed  ,A1     assign message to address register A1
        move.b #14 , D0          trap 14 output msg
        trap #15                 trap 15 interpt D0
        move.l   #150,D1               store 150 in D0 
        move.b   #23,D0                trap 23 
        trap   #15                     trap 15 interpt D0 
        lea info_feed  , A1     assign message to address register A1
        move.b #4 ,D0        trap 4 for user input
        trap #15             trap 15 interpt D0 
        cmp #1 , D1          compare 1 to d1 
        beq  journey  
        cmp #2 , D1         compare 2 to d1 
        beq mission1_prep

*-------------------------------------------------------
*-----------------------Horse feed 2--------------------
* Multiplies feed by no of horses
*------------------------------------------------------- 

 feed_mission2:
  
    move.l $16000 , D1
    lea feed_amount_msg , A1          assign message to address register A1
    move #17 , D0                     trap 17 outputs val in d0
    trap #15                         trap 15 interpt D0
    move.l   #150,D1     
    move.b   #23,D0                  trap 23 timer
    trap #15 
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1  
    move.b $17000 , D1    move memory 7000 to d1
    move.l $16000, D2     move memory 6000 to d2
    move.l $15000 , D3    move memory 5000 to d3
    mulu D1 , D3         mul d1 by d3
    move.l D3 , $19000    move d3 to memory 9000
    cmp D2 , D3          compare d2 by d3
    blt     plenty_feed2 branch if less than 
    cmp D2 , D3          compare d2 by d3
    bgt not_enough_feed2  branch if greater than
*-------------------------------------------------------
*------------not enough feed --------------------
* checks if there is not enough feed
*-------------------------------------------------------    
    
not_enough_feed2:

        lea low_feed  ,A1 assign message to address register A1
       move.b #14 , D0          trap 14 output msg
       trap #15                 trap 15 interpt D0
        move.b #4 ,D0        trap 4 for user input
        trap #15             trap 15 interpt D0
        cmp #1 , D1          compare 1 to d1 
        beq  mission2_prep
        
*-------------------------------------------------------
*------------enough feed --------------------
*checks if there is enough feed
*-------------------------------------------------------     
        
plenty_feed2:  

   
        lea enough_feed  ,A1 assign message to address register A1
        move.b #14 , D0          trap 14 output msg
        trap #15                 trap 15 interpt D0
        move.l   #150,D1               store 150 in D0 
        move.b   #23,D0                trap 23 
        trap   #15                     trap 15 interpt D0 
   
        lea info_feed  , A1
        move.b #14 , D0          trap 14 output msg
        trap #15                 trap 15 interpt D0
        move.b #4 ,D0        trap 4 for user input
        trap #15             trap 15 interpt D0
        cmp #1 , D1
        beq  journey_mission2
        cmp #2 , D1
        beq mission2_prep
         
*-------------------------------------------------------
*-----------------------Waiting winter-----------------------
*waiting the winter with a good outcome 
*------------------------------------------------------- 
goodwait:
   
   
    lea     wait_Outcome_message_good , A1                assign message to address register A1
    move.b  #14,D0                                       
    trap    #15  
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15                                         
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 

    move.b #2 , D1
    move.b $17000, D2
    add D2 , D1
    move.b D1 , $17000    
    move.l #200 , D1
    move.l $16000 , D2
    add D1 , D2
    move.l D2 ,$16000
    bra     mission1_prep
*-------------------------------------------------------
*-----------------------Waiting winter-----------------------
*waiting the winter with a bad outcome 
*-------------------------------------------------------     
badwait:
   
   
    lea     wait_Outcome_message_bad , A1          assign message to address register A1
    move.b #14 , D0          trap 14 output msg
    trap #15                 trap 15 interpt D0
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15
    
    trap    #15                                           
    move.b #4 ,D0
    trap #15
    cmp #1 , D1
    
    move.l #100 , D1
    move.l $15000 , D2
    sub D2 , D1
    move.b D1 , $15000 

    bra     mission1_prep
*-------------------------------------------------------
*-----------------------Waiting winter-----------------------
*waiting the winter with a good outcome 
*------------------------------------------------------- 
goodwait2:
   
   

    lea     wait_Outcome_message_good , A1                assign message to address register A1
    move.b  #14,D0                                       
    trap    #15 
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15
                                       
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 

    move.b #4 , D1      move 4 to d1
    move.b $17000, D2    move memory 1500 to d2
    add D2 , D1         add d2 to d1
    move.b D1 , $17000   move d1 to memory 1500
    
    move.l #400 , D1    move 400 to d1
    move.l $16000 , D2   move memory 6000 to d2
    add D1 , D2         add d1 to d2
    move.l D2 , $16000   move d2 to memory d2
    bra     mission2_prep
*-------------------------------------------------------
*-----------------------Waiting winter-----------------------
*waiting the winter with a bad outcome 
*-------------------------------------------------------     
badwait2:

     
    lea     wait_Outcome_message_bad , A1          assign message to address register A1
    move.b #14 , D0          trap 14 output msg
    trap #15                     trap 15 interpt D0
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15
                                            
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 
    
    move.l #300 , D1    move 300 to d1
    move.l $15000 , D2   move memory 3000 to d2
    sub D2 , D1          add d2 to d1
    move.b D1 , $15000 move d1 to memory 1500

    bra     mission2_prep





*-------------------------------------------------------
*--------------------Horses Inventory---------------------
* Number of horses to be allocated to a mission 1
*------------------------------------------------------- 
horses:
  
    move.b $17000 , D1
    lea horses_amount_msg , A1       assign message to address register A1
    move #17 , D0
    trap #15             trap 15 interpt D0
    move.l   #150,D1      150 timer
    move.b   #23,D0       trap 23 in d0
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 
          
   move.b #6 , D2    available horses
   move.b D2 , $17000
    
   bra     mission1_prep

*-------------------------------------------------------
*--------------------Horses Inventory---------------------
* Number of horses to be allocated to a mission 2 
*-------------------------------------------------------   
horses_mission2:
    
  
     move.b $17000 , D1
    lea horses_amount_msg , A1       assign message to address register A1
    move #17 , D0
    trap #15             trap 15 interpt D0
    move.l   #150,D1      150 timer
    move.b   #23,D0       trap 23 in d0
    trap #15         
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 

    
   bra     mission2_prep

rate:
    bsr     endl
    bsr     decorate
    lea     rate_msg,A1            assign message to address register A1
    move.b  #14,D0                  trap 14 for msg output
    trap    #15                     trap 15 interpt D0
    bsr     decorate
    rts
    
 *-------------------------------------------------------
*-----------------------cost of missin1----------------------
* outputs the cost of the first mission
*------------------------------------------------------- 
mission1_Cost_Awards:
    
    
    lea mission_Awards_and_cost , A1 assign message to address register A1
    move.b  #14,D0                  trap 14 for msg output
    trap    #15                     trap 15 interpt D0
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 

    move.l $17000 , D1         move 7000 to d1     
    move.b #2 , D2            move 2 to d2
    sub D2 , D1               sub d2 from d1
    move.l D1 , $17000         move d1 to 7000

    move.l $16000 , D1       move memory 6000 d1
    move.l #600 , D2        move 600 to d2
    add D2 , D1             add d2 and d1
    move.l D1 , $16000       move d1 to memory 6000
   
    move.l $10000 ,D1       move memory 10000 to d1 
    move.l #500 , D2        move 500 to d2
    add D2 ,D1              add d2 to d1
    move.l D1 , $10000      move d1 to 10000
 
     bra mission2_prep      branch mission2 prep
     
    
    
 *-------------------------------------------------------
*-----------------------cost of missin 2----------------------
* outputs the cost of the second mission
*-------------------------------------------------------     
                           
 mission2_Cost_Awards:
    
    
    lea mission_Awards_and_cost2 , A1 assign message to address register A1
    move.b  #14,D0                  trap 14 for msg output
    trap    #15                     trap 15 interpt D0
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 
    move.l $17000 , D1    move memory 7000 d1         
    move.b #4 , D2       move 4 to d2
    sub D2 , D1          sub d2 from d1
    move.l D1 , $17000    move d1 to memory 7000

    move.l $16000 , D1    move 6000 to memory d1
    move.l #700 , D2     move 700 , d2
    add D2 , D1          add d2 , d1
    move.l D1 , $16000    move d1 6000
   
    move.l $10000 ,D1    move 10000 to d1
    move.l #700 , D2     move 700 to d2
    add D2 ,D1           add d2 to d1
    move.l D1 , $10000   move d1 to memory 10000
   
    bra end_Game         branch end game

    
*-------------------------------------------------------
*------------------Mission 1 Distance---------------------
* Distance to battle location
*------------------------------------------------------- 
journey:
    
    lea     journey_msg,A1 assign message to address register A1
    move.b  #14,D0                  trap 14 for msg output
    trap    #15                     trap 15 interpt D0
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15
    move.l $16000 , D1               move memory 6000 d1
    move.l $19000, D2                move memory 9000 d2
    
    sub #200 , D1                   sub 200 from d1
    sub D2 , D1                     sub d1 from d2    
    move.l  D1 ,$16000               move d1 to memory 6000    
    move.l $10000 , D1              move 10000 to memory d1
    move.l $13000, D2               move 13000 to memory d1
    
    sub #200 , D1                   sub 200 from d1
    sub D2 , D1                     sub d1 from d2    
    move.l  D1 ,$10000              move d1 to memory 10000  
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 
    bra mission1         bra mission1
 *-------------------------------------------------------
*------------------Mission 2 journey---------------------
* Cost of the journey for mission 2
*------------------------------------------------------- 
journey_mission2:
    
    lea     journey_msg,A1 assign message to address register A1
    move.b  #14,D0                  trap 14 for msg output
    trap    #15                     trap 15 interpt D0
    move.l   #150,D1               store 150 in D0 
    move.b   #23,D0                trap 23 
    trap   #15                     trap 15 interpt D0
    move.l $16000 , D1               move memory 6000 d1
    move.l $19000, D2                move memory 9000 d2
    sub #400 , D1                   sub 400 from d1
    sub D2 , D1                     sub d2 from d1
    move.l  D1 ,$16000
    
    move.l $10000 , D1              move memory 10000 d1
    move.l $13000, D2               move memory 13000 d2
    sub #400 , D1                   sub 400 from d1
    sub D2 , D1                     sub d2 from d1
    move.l  D1 ,$10000              move d1 memory  $10000
    
    move.b #4 ,D0        trap 4 for user input
    trap #15             trap 15 interpt D0
    cmp #1 , D1          compare 1 to d1 
    bra mission2         branch to mission2
    
    
    
    

*-------------------------------------------------------
*-----------------------Soldiers----------------------
* Number of soldiers for mission 1. This als determines 
* cost of the soliders 
*-------------------------------------------------------   
soldiers:
   
    move.b $18000 , D1
    lea soliders_amount_msg , A1  assign message to address register A1
    move #17 , D0        trap 17 output val d0
    trap #15             trap 15 interpt D0
    move.l   #150,D1     timer is 50 
    move.b   #23,D0      trap 23 for timer
    trap #15             trap 15 interpt D0
    move.b #4 ,D0                   trap 4 for user input
    trap #15                        trap 15 interpt D0
    cmp #1 , D1                     compare 1 to d1
    move.b $18000 , D1               store val in memory 8000 in d1
    move.l $10000, D2               store val in memory 10000 in d2
    move.l $12000 , D3              store val in memory 8000 in d1
    mulu D1 , D3                    mul d1 by d3
    move.l  D3 , $13000             move d3 to 13000
    cmp D2 , D3                     compare d2 to d3
    blt     plenty_gold             branch if less than
    cmp D2 , D3                     compare d2 to d3             
    bgt not_enough_gold             branch if greater than
*-------------------------------------------------------
*-----------------------not_enough_gold----------------------
* outputs if you dont have enough gold
*-------------------------------------------------------     
   
    
not_enough_gold:

        lea low_gold  ,A1   assign message to address register A1
        move.b  #14,D0      trap 14 for msg output
        trap    #15         trap 15 interpt D0
        move.l   #150,D1               store 150 in D0 
        move.b   #23,D0                trap 23 
        trap   #15                     trap 15 interpt D0    
        move.b #4 ,D0        trap 4 for user input
        trap #15             trap 15 interpt D0
        cmp #1 , D1          compare 1 to d1
        beq  mission1_prep   branch if equal to
*-------------------------------------------------------
*-----------------------enough_gold----------------------
* outputs if you have enough gold
*-------------------------------------------------------             
plenty_gold:  

   
        lea enough_gold  ,A1     assign message to address register A1
        move.b  #14,D0          trap 14 for msg output
        trap    #15             trap 15 interpt D0
        move.l   #150,D1               store 150 in D0 
        move.b   #23,D0                trap 23 
        trap   #15                     trap 15 interpt D0
        move.b #4 ,D0           trap 4 for user input
        trap #15                trap 15 interpt D0
        cmp #1 , D1             copare 1 to d1
        
        lea info_gold  ,A1      msg stores a1
        move.b  #14,D0          trap 14 for msg output
        trap    #15             trap 15 interpt D0
        
        
        move.b #4 ,D0           trap 4 for user input
        trap #15                trap 15 interpt D0
        cmp #1 , D1             compare 1 to d1
        beq  mission1_prep      branch if equal to 
        blt invalid


            
*-------------------------------------------------------
*-----------------------Soldiers----------------------
* Number of soldiers for mission 2. This als determines 
* cost of the soliders 
*-------------------------------------------------------   
soldiers_mission2:
   

    move.b $18000 , D1
    lea soliders_amount_msg , A1  assign message to address register A1
    move #17 , D0        trap 17 output val d0
    trap #15             trap 15 interpt D0
    move.l   #150,D1     timer is 50 
    move.b   #23,D0      trap 23 for timer
    trap #15             trap 15 interpt D0
 
    move.b #4 ,D0               trap 4 for user input
    trap #15                    trap 15 interpt D0
    cmp #1 , D1                 compare 1 to D1
    move.b $18000 , D1           move 8000 to d1
    move.l $10000, D2           move 10000 to d2
    move.l $12000 , D3         move 12000 to d3
    mulu D1 , D3               multiply d1 by d1
    move.l  D3 , $13000        move d3 to memory d3
    cmp D2 , D3                compare d2 to d3
    blt     plenty_gold2        branchif less than
    cmp D2 , D3                 compare d2 to d3
    bgt not_enough_gold2        branchif greater than
*-------------------------------------------------------
*-----------------------not_enough_gold2----------------------
* outputs if you dont have enough gold
*-------------------------------------------------------     
    
not_enough_gold2:

        lea low_gold  ,A1       msg in a1
        move.b  #14,D0          trap 14 msg output
        trap    #15             trap 15 interpt D0
        move.l   #150,D1               store 150 in D0 
        move.b   #23,D0                trap 23 
        trap   #15                     trap 15 interpt D0
        move.b #4 ,D0            trap 4 for user input
        trap #15                    trap 15 interpt D0
        cmp #1 , D1              compare 1 to d1
        beq  mission2_prep        branch if equal
*-------------------------------------------------------
*-----------------------enough_gold2----------------------
* outputs if you have enough gold
*-------------------------------------------------------            
plenty_gold2:  

   
        lea enough_gold  ,A1    msg in a1  
        move.b  #14,D0          trap 14 msg output
        trap    #15             trap 15 interpt D0
        move.l   #150,D1               store 150 in D0 
        move.b   #23,D0                trap 23 
        trap   #15                     trap 15 interpt D0
        move.b #4 ,D0           move 4 to d0
        trap #15                trap 15 interpt D0
        cmp #1 , D1              compare 1 to d0
         
        lea info_gold  ,A1      store msg in a1
        move.b  #14,D0          trap 14 msg output
        trap    #15              trap 15 interpt D0
       
        
        move.b #4 ,D0          trap 4 for user input
        trap #15                trap 15 interpt D0
        cmp #1 , D1             compare 1 to d0
        beq  mission2_prep       brnch if equal to mission prep 2
        

*-------------------------------------------------------
*---Game Play (Mission Progress, Battle Maneuvers)------
*------------------------------------------------------- 
gameplay:
    bsr     endl
    bsr     decorate

    move.b  #14,D0
    trap    #15
    bsr     decorate
    bsr     collision
    rts
end_Game:

        lea ending_msg , A1  ending msg
        move.b #14 , D0      trap 14 msg output D0
        trap #15            trap 15 interpt D0
        move.l   #150,D1               store 150 in D0 
        move.b   #23,D0                trap 23 
        trap   #15                     trap 15 interpt D0

        move.l $16000 , D1      move val in 6000 D1
        move.l $10000 , D2     move val in 10000 D2
        add D1 , D2            add D2 and D1
        move.l D2 , $14000     store D2 in 14000
        
        bra replay
*-------------------------------------------------------
*-----------------Heads Up Display (Score)--------------
* Retrieves the score from memory location
*-------------------------------------------------------   
hud:

    bsr     endl
    bsr     decorate

    move.b  #14,D0      trap 14 msg output
    trap    #15         trap 15 interpt D0
    move.b  (A3),D1     retrieve the value A3 point to and move to D1
    move.b  #3,D0       move literal 3 to D0
    trap    #15         intrepret value in D0, which 3 which displays D1
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Taking Fire---------------------
* This could be used for collision detection, if 
*-------------------------------------------------------
collision:
    move.b  #mine_loc,D1
    cmp     #100,D1 is( x == 100)?
	bne     collision_miss if x is equal to 100, then hit
collision_hit:
    *hit

       move.b #14 , D0          trap 14 output msg
       trap #15                 trap 15 interpt D0
    rts
    
collision_miss:
    *miss

    move.b #14 , D0          trap 14 output msg
    trap #15                 trap 15 interpt D0
    rts

*-------------------------------------------------------
*--------------------------Loop-------------------------
*-------------------------------------------------------
loop:
    move.b  #5, D3 loop counter D3=5
next:

       move.b #14 , D0          trap 14 output msg
       trap #15                 trap 15 interpt D0
	sub     #1,D3   decrement loop counter
    bne     next    repeat until D0=0

*-------------------------------------------------------
*------------------Screen Decoration--------------------
*-------------------------------------------------------
decorate:
    move.b  #60, D3
    bsr     endl
out:

    move.b  #14,D0   trap 14 msg output
    trap    #15      trap 15 interpt D0
	sub     #1,D3   decrement loop counter
    bne     out	    repeat until D0=0
    bsr     endl
    rts
    
clear_screen: 
    move.b  #11,D0      clear screen
    move.w  #$ff00,D1
    trap    #15
    rts
*-------------------------------------------------------
*------------------------Replay-------------------------
*-------------------------------------------------------
replay:
    bsr     endl
    lea replay_msg , A1
    move.b #14 , D0          trap 14 output msg
    trap #15                 trap 15 interpt D0
    
    move.b  #4,D0   move 4 to d0
    trap    #15   trap 15 interpt D0
    cmp #1 , D1   compare 1 to d1
    beq welcome   branch if equal


endl:
    movem.l D0/A1,-(A7)
    move    #14,D0
    lea     crlf,A1
    trap    #15
    movem.l (A7)+,D0/A1
    rts
    
invalid:


       move.b #14 , D0          trap 14 output msg
       trap #15                 trap 15 interpt D0
       rts
*-------------------------------------------------------
*-------------------Data Delarations--------------------
*-------------------------------------------------------

crlf:           dc.b    $0D,$0A,0

replay_msg:     dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'Press 1 to replay game'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0

invalid_msg:    dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'My lord that is an invalid selection'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0

Buy_feed_msg:    dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'you bough 100 feed and it cost 200'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0

Buy_horses_msg:       dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'you bough 2 horses and it cost 300'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0
                
Buy_soliders_msg:   dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'you bough 2 soliders and it cost 400'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0


horses_amount_msg: dc.b    '************************************************************'
                   dc.b    $0D,$0A
                  dc.b    'The number of horses you have is :'
                  dc.b    $0D,$0A
                  dc.b    '************************************************************'
                  dc.b    $0D,$0A,0

buy_suff_msg:     dc.b    '************************************************************'
                  dc.b    $0D,$0A
                  dc.b    'To buy feed press 1'
                  dc.b    $0D,$0A
                  dc.b    'To buy horses press 2'
                  dc.b    $0D,$0A
                  dc.b    'To buy soliders press 3'
                  dc.b    $0D,$0A
                  dc.b    'To return to mission prep 4'
                  dc.b    $0D,$0A
                  dc.b    '************************************************************'
                  dc.b    $0D,$0A,0


soliders_amount_msg:    dc.b    '************************************************************'
                        dc.b    $0D,$0A
                        dc.b    'The number of soliders you have is :'
                        dc.b    $0D,$0A
                        dc.b    '************************************************************'
                        dc.b    $0D,$0A,0

                   
low_feed:   dc.b    '************************************************************'
            dc.b    $0D,$0A
            dc.b    'My lord we dont have enough feed to go to Battle'
            dc.b    $0D,$0A
            dc.b    'Press 1 to return to preparaton '
            dc.b    $0D,$0A
            dc.b    'I suggest we wait the winter till we have enough'
            dc.b    $0D,$0A
            dc.b    '************************************************************'
            dc.b    $0D,$0A,0
            
            
shop_msg:                dc.b    '************************************************************'
                         dc.b    $0D,$0A
                         dc.b    'Welcome to the shop to view feed press 1. '
                         dc.b    $0D,$0A
                         dc.b    'To view horses press 2 '
                         dc.b    $0D,$0A
                         dc.b    'To view soliders press 3 '
                         dc.b    $0D,$0A
                         dc.b    'To buy 4'
                         dc.b    $0D,$0A
                         dc.b    '************************************************************'
                         dc.b    $0D,$0A,0  

         
mission_Awards_and_cost: dc.b    '************************************************************'
                         dc.b    $0D,$0A
                         dc.b    'My lord we have taken Algard Castle. '
                         dc.b    $0D,$0A
                         dc.b    'We gained 600 feed and 500 gold '
                         dc.b    $0D,$0A
                         dc.b    'Our next target is Garth Castle .Press 1 to go to preparaton '
                         dc.b    $0D,$0A
                         dc.b    'I suggest we wait the winter till we have enough'
                         dc.b    $0D,$0A
                         dc.b    '************************************************************'
                         dc.b    $0D,$0A,0   

          
mission_Awards_and_cost2: dc.b    '************************************************************'
                         dc.b    $0D,$0A
                         dc.b    'My lord we have taken Garth Castle.'
                         dc.b    $0D,$0A
                         dc.b    ' we gained 700 gold and 700 feed and lost 4 horses  '
                         dc.b    $0D,$0A
                         dc.b    '************************************************************'
                         dc.b    $0D,$0A,0    
                 
enough_feed:          dc.b    '************************************************************'
                      dc.b    $0D,$0A
                      dc.b    'My lord we have plenty of feed for the mission'
                      dc.b    $0D,$0A
                      dc.b    'We can wait the winter or attack now press 1 to attack or 2 ' 
                      dc.b    $0D,$0A
                      dc.b    '2 to return'
                      dc.b    $0D,$0A
                      dc.b    '************************************************************'
                      dc.b    $0D,$0A,0
                      
info_feed:            dc.b    '************************************************************'
                      dc.b    $0D,$0A
                      dc.b    'My lord we can attack now or return to preperation at the '
                      dc.b    $0D,$0A
                      dc.b    'castle. Press 1 to attack now or 2 to return to prepertion'
                      dc.b    $0D,$0A
                      dc.b    '************************************************************'
                      dc.b    $0D,$0A,0

low_gold:   dc.b    '************************************************************'
            dc.b    $0D,$0A
            dc.b    'My lord we dont have enough gold to go to Battle'
            dc.b    $0D,$0A
            dc.b    'Press 1 to return to preparaton  '
            dc.b    $0D,$0A
            dc.b    'I suggest we wait the winter till we have enough'
            dc.b    $0D,$0A
            dc.b    '************************************************************'
            dc.b    $0D,$0A,0
                      
enough_gold:          dc.b    '************************************************************'
                      dc.b    $0D,$0A
                      dc.b    'My lord we have plenty of gold for the mission'
                      dc.b    $0D,$0A
                      dc.b    'We can wait the winter or attack now'            
                      dc.b    $0D,$0A
                      dc.b    '************************************************************'
                      dc.b    $0D,$0A,0
                      
info_gold:            dc.b    '************************************************************'
                      dc.b    $0D,$0A
                      dc.b    'My lord return to preperation at the '
                      dc.b    $0D,$0A
                      dc.b    'castle. Press 1 to return to prepertion'
                      dc.b    $0D,$0A
                      dc.b    '************************************************************'
                      dc.b    $0D,$0A,0


                      
start_msg:    dc.b    '************************************************************'
              dc.b    $0D,$0A
              dc.b    'The year is 133 of the first era. The king is dead and and a cival war has '
              dc.b    $0D,$0A
              dc.b    'started for his throne. As the rightful heir you must secure all the '
              dc.b    $0D,$0A
              dc.b    'castles in the kingdom and secure your reign '
              dc.b    $0D,$0A
              dc.b    '************************************************************'
              dc.b    $0D,$0A,0
              
Go_to_mission1_prep:  dc.b    '************************************************************'
              dc.b    $0D,$0A
              dc.b    'To prepare for the mission press 1 '
              dc.b    $0D,$0A
              dc.b    '************************************************************'
              dc.b    $0D,$0A,0

feed_amount_msg:     dc.b    '************************************************************'
                     dc.b    $0D,$0A
                     dc.b    'Your Grace the amount of feed you have is: '
                     dc.b    $0D,$0A
                     dc.b    '************************************************************'
                     dc.b    $0D,$0A,0
              
ending_msg:    dc.b    '************************************************************'
               dc.b    $0D,$0A
               dc.b    'Congrates you have completed ZorkQuest and your score was: '
               dc.b    $0D,$0A
               dc.b    '************************************************************'
               dc.b    $0D,$0A,0

wait_OutCome_message_good:  dc.b    '************************************************************'
                            dc.b    $0D,$0A
                            dc.b    'My lord you chose to wait over the winter and our farmers have reported  '
                            dc.b    $0D,$0A
                            dc.b    'we have had a good year and a crop of feed have been farmed '
                            dc.b    $0D,$0A
                            dc.b    'Our scouts have reported that due to the the crop that additional horses '
                            dc.b    $0D,$0A
                            dc.b    'have been bred. we could attack now or wait again or attck'
                            dc.b    $0D,$0A
                            dc.b    '******************************************************************************'
                            dc.b    $0D,$0A,0  
          
wait_OutCome_message_bad:    dc.b    '************************************************************'
                             dc.b    $0D,$0A
                             dc.b    'My lord you chose to wait over the winter and our farmers have reported'
                             dc.b    $0D,$0A
                             dc.b    'we have had a famine this year and our horses have starved '
                             dc.b    $0D,$0A
                             dc.b    'we lost feed'
                             dc.b    $0D,$0A
                             dc.b    'we could attack now or wait again castle so we should attack soon'
                             dc.b    $0D,$0A
                             dc.b    '************************************************************'
                             dc.b    $0D,$0A,0  
     

             
battle_msg:   dc.b    '************************************************************'
              dc.b    $0D,$0A
              dc.b    'My lord we have arrived at Algard castle  '
              dc.b    $0D,$0A
              dc.b    'we can attack now or we can wait. '
              dc.b    $0D,$0A
              dc.b    ' Press 1 to attack'
              dc.b    $0D,$0A
              dc.b    '************************************************************'
              dc.b    $0D,$0A,0             
                         
battle_msg2:   dc.b    '************************************************************'
              dc.b    $0D,$0A
              dc.b    'My lord we have arrived at Garth castle  '
              dc.b    $0D,$0A
              dc.b    'we can attack now or we can wait. '
              dc.b    $0D,$0A
              dc.b    ' Press 1 to attack'
              dc.b    $0D,$0A
              dc.b    '************************************************************'
              dc.b    $0D,$0A,0             
                                       
                      
 Algard_Castle_msg:   dc.b    '************************************************************'
                      dc.b    $0D,$0A
                      dc.b    'Preparing to assault Algard Castle. To see how '
                      dc.b    $0D,$0A
                      dc.b    'mutch feed you have or to attack press 1. To see how many   '
                      dc.b    $0D,$0A
                      dc.b    'horses you have press 2.  '
                      dc.b    $0D,$0A
                      dc.b    'Press 3 to see soliders available for attack.  '
                      dc.b    $0D,$0A
                      dc.b    'I suggest you make sure you have'
                      dc.b    $0D,$0A
                      dc.b    'enough of everythig or press 4 or 5 to wait out the winter'
                      dc.b    $0D,$0A
                      dc.b    'Press 6 to go to the store'
                      dc.b    $0D,$0A
                      dc.b    '************************************************************'
                      dc.b    $0D,$0A,0
                      
 Garth_Castle_msg:   dc.b    '************************************************************'
                      dc.b    $0D,$0A
                      dc.b    'Preparing to assault Garth Castle. To see how '
                      dc.b    $0D,$0A
                      dc.b    'mutch feed you have or to attack press 1. To see how many   '
                      dc.b    $0D,$0A
                      dc.b    'horses you have press 2. Press 3 to see soliders '
                      dc.b    $0D,$0A
                      dc.b    'available for attack.I suggest you make sure you have '
                      dc.b    $0D,$0A
                      dc.b    'enough of everythig or press 4 or 5 to wait out the winter'
                      dc.b    $0D,$0A
                      dc.b    'Press 6 to go to the store'
                      dc.b    $0D,$0A
                      dc.b    '************************************************************'
                      dc.b    $0D,$0A,0

intro_msg:    dc.b    '************************************************************'
              dc.b    $0D,$0A
              dc.b    'My lord i am your personal assistant. We need our conquest to be successful'
              dc.b    $0D,$0A
              dc.b    'To do this we will need gold, horse feed ,soliders and a number of horses'
              dc.b    $0D,$0A
              dc.b    'At the moment we have 800 feed , 300 gold , 6 horses and 8 soliders'
              dc.b    $0D,$0A
              dc.b    '************************************************************'
              dc.b    $0D,$0A,0                
             
welcome_msg:    dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'Welcome to ZorkQuest  '
                dc.b    $0D,$0A
                dc.b    '(Press enter somtimes to continue'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0
     
rate_msg:       dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'One Third[1], Two Thirds[2], Standard Charge[3], ' 
                dc.b    $0D,$0A
                dc.b    'Full Charge[4], Flank Charge[5] units feed per click'
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0 
                
journey_msg:    dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'We are travelling towards Algard castle'
                dc.b    $0D,$0A
                dc.b    'cost 200 feed and gold.'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0 

draw_msg:       dc.b    'Draw Screen !',0


health:     ds.w    1
score:      ds.w    1 reserve space for score

    end start

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
