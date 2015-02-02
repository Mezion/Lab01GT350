//
//  ViewController.m
//  Lab01-Ski
//
//  Created by Legault, Mathieu on 2015-01-21.
//  Copyright (c) 2015 Legault, Mathieu. All rights reserved.
//

#import "ViewController.h"

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





@end

@implementation ViewController
{
    NSMutableArray *tableParticipantsData;
    NSMutableDictionary *classement;
    int nextId;
    bool running;
    NSTimeInterval startTime;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Init table data?????
    tableParticipantsData = [[NSMutableArray alloc] init];
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
    return [tableParticipantsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableParticipantsData objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)buttonAdd:(UIButton *)sender {
    if (_fieldNom.text.length <= 0 || _fieldPrenom.text.length <= 0 || _fieldPays.text.length <= 0) {
        NSLog(@"Fields are not complete. Cannot add.");
    }
    else{
        NSString *participant = [NSString stringWithFormat:@"%@%@%@%@%@%@%d%@", _fieldPrenom.text, @" ", _fieldNom.text, @" | ", _fieldPays.text, @" | ", nextId, @" "];
        nextId++;
        bool alreadyPresent = false;
        for(NSString *string in tableParticipantsData){
            if([string isEqualToString:participant]){
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
        self.btnConfirmer.enabled = NO;
        self.buttonDNF.enabled = YES;
    }
    else{
        //stop timer
        [sender setTitle:@"GO" forState:UIControlStateNormal];
        running = false;
        self.stepperPorte.enabled = YES;
        self.btnConfirmer.enabled = YES;
        sender.enabled = NO;
        self.buttonDNF.enabled = NO;
    }
}
- (IBAction)startCompetition:(UIButton *)sender {
    if([self.startCompetition.currentTitle isEqualToString:@"Arrêter la compétition"]) {
        nextId = 0;
        self.buttonGo.enabled = false;
        self.buttonAdd.enabled = true;
        [tableParticipantsData removeAllObjects];
        [self.tableView reloadData];
        [sender setTitle:@"Commencer la compétition" forState:UIControlStateNormal];
        self.textViewCourant.hidden = YES;
    }
    else {
        if([tableParticipantsData count] == 0) {
            NSLog(@"Doit avoir au moins un participant");
            return;
        }
        self.fieldNom.text = @"";
        self.fieldPays.text = @"";
        self.fieldPrenom.text = @"";
        self.buttonGo.enabled = true;
        self.buttonAdd.enabled = false;
        self.buttonDNF.hidden = NO;
        for(int i = 0; i < 3; i++) {
            if([tableParticipantsData count] == i) break;
            //NSLog(tableParticipantsData);
            NSString *participant = [tableParticipantsData objectAtIndex:i];
            if(i == 0) {
                self.textViewCourant.text = [NSString stringWithFormat:@"Skyeur Courant: %@", participant];

            } else if (i == 1) {
                self.textViewCourant.text = [NSString stringWithFormat:@"%@\nProchain skyeur: %@", self.textViewCourant.text, participant];
                
            } else {
                self.textViewCourant.text = [NSString stringWithFormat:@"%@\nTroisième skyeur: %@", self.textViewCourant.text, participant];
                
            }
        }
        self.textViewCourant.hidden = NO;
        [sender setTitle:@"Arrêter la compétition" forState:UIControlStateNormal];
    }
    
    sender.enabled = true;
    
}

- (IBAction)stepperValueChange:(UIStepper *)sender {
    if(self.stepperPorte.value == 0 || self.stepperPorte.value == 1)
        self.lblPorte.text = [NSString stringWithFormat:@"%d porte manquée", (int)self.stepperPorte.value];
    else
        self.lblPorte.text = [NSString stringWithFormat:@"%d portes manquées", (int)self.stepperPorte.value];
}
- (IBAction)confirmerDescenteClick:(UIButton *)sender {
    self.buttonGo.enabled = YES;
    self.btnConfirmer.enabled = NO;
}
- (IBAction)buttonDNFClick:(UIButton *)sender {
    // more to handle later on...
    
    [self.buttonGo setTitle:@"GO" forState:UIControlStateNormal];
    running = false;
    self.buttonDNF.enabled = NO;
}



@end
