//
//  ViewController.m
//  Lab01-Ski
//
//  Created by Legault, Mathieu on 2015-01-21.
//  Copyright (c) 2015 Legault, Mathieu. All rights reserved.
//

#import "ViewController.h"
#import "Participant.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fieldPrenom;
@property (weak, nonatomic) IBOutlet UITextField *fieldNom;
@property (weak, nonatomic) IBOutlet UITextField *fieldPays;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *TIMELabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonGo;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UIButton *startCompetition;
@property (weak, nonatomic) IBOutlet UIButton *buttonDNF;
@property (weak, nonatomic) IBOutlet UITextView *textViewCourant;
@property (weak, nonatomic) IBOutlet UILabel *lblPorte;
@property (weak, nonatomic) IBOutlet UIStepper *stepperPorte;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmer;
@property (weak, nonatomic) IBOutlet UILabel *lblCourseNb;
@property (weak, nonatomic) IBOutlet UITableView *tableResults;
@property (weak, nonatomic) IBOutlet UILabel *lblFinal;
    @property (weak, nonatomic) IBOutlet UITextView *textViewDescentes;

@end

@implementation ViewController
{
    NSMutableArray *tableParticipantsData;
    NSMutableArray *tableParticipantsResults;
    NSMutableArray *tableStaticParticipantData;
    NSMutableDictionary *classement;
    int nextId;
    bool running;
    NSTimeInterval startTime;
    Participant *courant;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Init table data?????
    tableParticipantsData = [[NSMutableArray alloc] init];
    tableParticipantsResults = [NSMutableArray new];
    nextId = 0;
    classement = [[NSMutableDictionary alloc] init];
    // use this for the classement
    // key(participant) value(classement #)
    _TIMELabel.text=@"0:00.0";
    running = false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        return [tableParticipantsData count];
    }
    else if(tableView == self.tableResults)
    {
        return [tableParticipantsResults count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        static NSString *partTableIdentifier = @"PartTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:partTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:partTableIdentifier];
        }
        
        Participant *participant = [tableParticipantsData objectAtIndex:indexPath.row];
        NSString *cellText = [NSString stringWithFormat:@"%@%@%@%@%@%@%d%@", participant.getPrenom, @" ", participant.getNom, @" | ", participant.getPays, @" | ", participant.getId, @" "];
        cell.textLabel.text = cellText;
        return cell;
    }
    else if(tableView == self.tableResults){
        static NSString *resultTableIdentifier = @"ResultTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resultTableIdentifier];
        }
        
        //Participant *participant = [classement objectForKey:[tableParticipantsResults objectAtIndex:indexPath.row]];
        NSArray *sortedArray;
        sortedArray = [tableParticipantsResults sortedArrayUsingSelector:@selector(compare:)];
        Participant *participant = [sortedArray objectAtIndex:indexPath.row];
        NSString *cellText2 = [NSString stringWithFormat:@"%@%d%@%@%@%@%@%f", @"Pos:", indexPath.row, @" | ", participant.getPrenom, @" ", participant.getNom, @" | Temps total: ", participant.getSumOfResults.doubleValue];
        cell.textLabel.text = cellText2;
        return cell;
    }
    else
    {
        return NULL;
    }
    
    
}

- (IBAction)buttonAdd:(UIButton *)sender {
    if (_fieldNom.text.length <= 0 || _fieldPrenom.text.length <= 0 || _fieldPays.text.length <= 0) {
        NSLog(@"Fields are not complete. Cannot add.");
    }
    else{
        Participant *participant = [Participant new];
        [participant setPrenom:_fieldPrenom.text];
        [participant setNom:_fieldNom.text];
        [participant setPays:_fieldPays.text];
        [participant setId:nextId];
        nextId++;
        bool alreadyPresent = false;
        for(Participant *part in tableParticipantsData){
            if(part.getId == participant.getId){
                alreadyPresent = true;
            }
        }
        if(alreadyPresent == false){
            [tableParticipantsData addObject:participant];
            [self.tableView reloadData];
        }
    }
}


- (void)updateTime
{
    if(running == false) return;
    
    //calculate elapsed time
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - startTime;
    
    //Extract out the minutes, seconds, and fraction of seconds from elapsed time
    int mins = (int)(elapsed/60.0);
    elapsed -= mins * 60;
    int secs = (int)(elapsed);
    elapsed -= secs;
    int fraction = elapsed * 10.0;
    
    //Update label (format 0:00.0)
    _TIMELabel.text = [NSString stringWithFormat:@"%u:%02u.%u", mins, secs, fraction];
    
    //call updateTime again after 0.1 second
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

- (IBAction)Start:(UIButton *)sender
{
    if(!running){
        //Start timer
        running = true;
        startTime = [NSDate timeIntervalSinceReferenceDate];
        [sender setTitle:@"STOP" forState:UIControlStateNormal];
        [self updateTime];
        self.stepperPorte.enabled = NO;
        self.stepperPorte.alpha = 0.25;
        self.btnConfirmer.enabled = NO;
        self.btnConfirmer.alpha = 0.25;
        self.buttonDNF.enabled = YES;
        self.buttonDNF.alpha = 1.0;
    }
    else{
        //stop timer
        [sender setTitle:@"GO" forState:UIControlStateNormal];
        running = false;
        self.stepperPorte.enabled = YES;
        self.stepperPorte.alpha = 1.0;
        self.btnConfirmer.enabled = YES;
        self.btnConfirmer.alpha = 1.0;
        sender.enabled = NO;
        sender.alpha = 0.25;
        self.buttonDNF.enabled = NO;
        self.buttonDNF.alpha = 0.25;
    }
}

- (IBAction)startCompetition:(UIButton *)sender {
    if([self.startCompetition.currentTitle isEqualToString:@"Arrêter la compétition"]) {
        nextId = 0;
        self.buttonGo.enabled = false;
        self.buttonGo.alpha = 0.25;
        self.buttonAdd.enabled = true;
        self.buttonAdd.alpha = 1.0;
        self.fieldNom.enabled = true;
        self.fieldNom.alpha = 1.0;
        self.fieldPays.enabled = true;
        self.fieldPays.alpha = 1.0;
        self.fieldPrenom.enabled = true;
        self.fieldPrenom.alpha = 1.0;
        [tableParticipantsData removeAllObjects];
        [self.tableView reloadData];
        [sender setTitle:@"Commencer la compétition" forState:UIControlStateNormal];
        self.buttonDNF.hidden = YES;
        self.textViewCourant.hidden = YES;
        self.textViewDescentes.hidden = YES;
    }
    else {
        if([tableParticipantsData count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Impossible de débuter"
                                                           message:@"Il doit y avoir au moins un participant."
                                                          delegate:nil
                                                 cancelButtonTitle:@"Retour.."
                                                 otherButtonTitles:nil];
            [alert show];
            return;
        }
        tableStaticParticipantData = [NSMutableArray arrayWithArray:tableParticipantsData];
        self.fieldNom.text = @"";
        self.fieldPays.text = @"";
        self.fieldPrenom.text = @"";
        self.buttonGo.enabled = true;
        self.buttonGo.alpha = 1.0;
        self.fieldNom.enabled = false;
        self.fieldNom.alpha = 0.25;
        self.fieldPays.enabled = false;
        self.fieldPays.alpha = 0.25;
        self.fieldPrenom.enabled = false;
        self.fieldPrenom.alpha = 0.25;
        self.buttonAdd.enabled = false;
        self.buttonAdd.alpha = 0.25;
        self.buttonDNF.hidden = NO;
        [self setCurrentRunner];
        [self setDescentesAVenir];
        self.textViewCourant.hidden = NO;
        self.textViewDescentes.hidden = NO;
        [sender setTitle:@"Arrêter la compétition" forState:UIControlStateNormal];
        [sender setEnabled:NO];
        [sender setAlpha:0.25];
    }
    
    sender.enabled = true;
    sender.alpha = 1.0;
    
}

-(void) setCurrentRunner
{
    for(int i = 0; i < 3; i++) {
        if([tableParticipantsData count] == i) break;
        Participant *participant = [tableParticipantsData objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"%@%@%@%@%d", participant.getPrenom, @" ", participant.getNom, @" | ", participant.getId];
        if(i == 0) {
            courant = participant;
            if([participant.getResultats count] < 2)
            {
                self.textViewCourant.text = [NSString stringWithFormat:@"Skyeur Courant: %@", name];
            }
            self.lblCourseNb.text = [NSString stringWithFormat:@"%@%d", @"Course #: ", [[courant getResultats] count] +1];
        } else if (i == 1) {
            if([participant.getResultats count] < 2)
            {
                self.textViewCourant.text = [NSString stringWithFormat:@"%@\nProchain skyeur: %@", self.textViewCourant.text, name];
            }
        } else {
            if([participant.getResultats count] < 2)
            {
                self.textViewCourant.text = [NSString stringWithFormat:@"%@\nTroisième skyeur: %@", self.textViewCourant.text, name];
            }
        }
    }
}
    
    -(void) setDescentesAVenir
    {
        self.textViewDescentes.text = @"";
        
        // premiere descente
        bool isOver = false;
        int nextNumber = 1;
        bool doItTwice = false;
        if([courant.getResultats count] == 0) {
            // deuxieme fois qu'on passe dans l'array
            doItTwice = true;
        }
        int i = courant.getId+1;
        
        while (!isOver) {
            if(i == [tableStaticParticipantData count]) {
                break;
            }
            Participant *participant = [tableStaticParticipantData objectAtIndex:i];
            NSString *name = [NSString stringWithFormat:@"%@%@%@%@%d", participant.getPrenom, @" ", participant.getNom, @" | ", participant.getId];
            self.textViewDescentes.text = [NSString stringWithFormat:@"%@\nSkyeur # %d: %@", self.textViewDescentes.text, nextNumber, name];
            nextNumber++;
            i++;
        }
        i = 0;
        isOver = false;
        
        if(doItTwice) {
            while(!isOver) {
                if(i == [tableStaticParticipantData count]) {
                    break;
                }
                Participant *participant = [tableStaticParticipantData objectAtIndex:i];
                NSString *name = [NSString stringWithFormat:@"%@%@%@%@%d", participant.getPrenom, @" ", participant.getNom, @" | ", participant.getId];
                self.textViewDescentes.text = [NSString     stringWithFormat:@"%@\nSkyeur # %d: %@",    self.textViewDescentes.text, nextNumber, name];
                nextNumber++;
                i++;
                
            }
        }
        /*self.textViewDescentes.text = [NSString stringWithFormat: @"%d", i];*/
    }

-(BOOL) checkIfCompetitionOver
{
    bool isOver = true;
    
    for(Participant *part in tableParticipantsData)
    {
        if([[part getResultats] count] < 2)
        {
            isOver = false;
        }
    }
    
    return isOver;
}

-(void) updateClassement
{
    [tableParticipantsResults removeAllObjects];
    [tableParticipantsResults addObjectsFromArray:tableParticipantsData];
    [self.tableResults reloadData];
}

- (IBAction)stepperValueChange:(UIStepper *)sender {
    if(self.stepperPorte.value == 0 || self.stepperPorte.value == 1)
        self.lblPorte.text = [NSString stringWithFormat:@"%d porte manquée", (int)self.stepperPorte.value];
    else
        self.lblPorte.text = [NSString stringWithFormat:@"%d portes manquées", (int)self.stepperPorte.value];
}

- (IBAction)confirmerDescenteClick:(UIButton *)sender {
    //do logic for end of race, calculate time & send runner to back. give runner results.
    //calc time
    _TIMELabel.text = [NSString stringWithFormat:@"%u:%02u.%u", 0, 0, 0];
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - startTime;
    elapsed += (self.stepperPorte.value * 30.0);
    Result *resultat = [Result new];
    [resultat setTime:elapsed];
    
    //give result
    [courant addResult:resultat];
    
    //send runner back
    [tableParticipantsData removeObjectAtIndex:0];
    [tableParticipantsData insertObject:courant atIndex:([tableParticipantsData count])];
    
    //update classement
    [self updateClassement];
    
    //check if competition over, if not proceed
    if([self checkIfCompetitionOver])
    {
        [self setCurrentRunner];
        self.buttonDNF.enabled = NO;
        self.buttonDNF.alpha = 0.25;
        self.buttonGo.enabled = NO;
        self.buttonGo.alpha = 0.25;
        self.btnConfirmer.enabled = NO;
        self.btnConfirmer.alpha = 0.25;
        self.lblCourseNb.text = @"Courses terminées.";
        
        [tableParticipantsResults removeAllObjects];
        [tableParticipantsResults addObjectsFromArray:tableParticipantsData];
        for(int i=3; i<[tableParticipantsResults count]; i++)
        {
            [tableParticipantsResults removeObjectAtIndex:i];
        }
        self.lblFinal.hidden = NO;
        
        [self.tableResults reloadData];
    }
    else
    {
        [self setCurrentRunner];
        [self setDescentesAVenir];
        self.buttonGo.enabled = YES;
        self.buttonGo.alpha = 1.0;
        self.btnConfirmer.enabled = NO;
        self.btnConfirmer.alpha = 0.25;
    }
}

- (IBAction)buttonDNFClick:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Voulez vous disqualifier ce joueur? " delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Checks For Approval
    if (buttonIndex == 1) {
        [self.buttonGo setTitle:@"GO" forState:UIControlStateNormal];
        running = false;
        self.buttonDNF.enabled = NO;
        self.buttonDNF.alpha = 0.25;
        _TIMELabel.text = [NSString stringWithFormat:@"%u:%02u.%u", 0, 0, 0];
        
        //give runner a null result entry & send runner to back
        //give result
        Result *resultat = [Result new];
        [resultat setTime:999.999];
        [courant addResult:resultat];
        
        //send runner back
        [tableParticipantsData removeObjectAtIndex:0];
        [tableParticipantsData insertObject:courant atIndex:([tableParticipantsData count])];
        
        //update classement
        [self updateClassement];
        
        //check if competition over, if not proceed
        if([self checkIfCompetitionOver])
        {
            [self setCurrentRunner];
            self.buttonDNF.enabled = NO;
            self.buttonDNF.alpha = 0.25;
            self.buttonGo.enabled = NO;
            self.buttonGo.alpha = 0.25;
            self.btnConfirmer.enabled = NO;
            self.btnConfirmer.alpha = 0.25;
            self.lblCourseNb.text = @"Courses terminées.";
            
            [tableParticipantsResults removeAllObjects];
            [tableParticipantsResults addObjectsFromArray:tableParticipantsData];
            for(int i=3; i<[tableParticipantsResults count]; i++)
            {
                [tableParticipantsResults removeObjectAtIndex:i];
            }
            self.lblFinal.hidden = NO;
            
            [self.tableResults reloadData];
        }
        else
        {
            [self setCurrentRunner];
            self.buttonGo.enabled = YES;
            self.buttonGo.alpha = 1.0;
            self.btnConfirmer.enabled = NO;
            self.btnConfirmer.alpha = 0.25;
        }
    } else {
        //do nothing because they selected no
    }
}



@end
