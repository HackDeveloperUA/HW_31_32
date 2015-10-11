
#import "ASStudent.h"

@implementation ASStudent

#define ARC4RANDOM_MAX      0x100000000


-(instancetype) init  {
    
    self = [super init];
    if (self) {
        
        self.name   = [self randomName];
        self.famaly = [self randomFamaly];
        
        float range = 6 - 2;
        self.averagePrice = ((float)arc4random() / ARC4RANDOM_MAX) * range + 2;
        
    }
    return self;
}

-(NSString*) randomFamaly {
    
    
    NSArray* arrFamaly = [NSArray arrayWithObjects: @"Smith",    @"Wilson",    @"Harris",   @"Clark",    @"Lee",
                          @"Johnson",  @"Moore",     @"Martin",   @"Lewis",    @"Hall",
                          @"Williams", @"Taylor",    @"Thompson", @"Perez",    @"Lopez",
                          @"Jones",    @"Walker",    @"Anderson", @"Garcia",   @"Turner",
                          @"Brown",    @"Hernandez", @"Thomas",   @"Martinez", @"Robinson",
                          @"Davis",    @"Adams",     @"Jackson",  @"Baker",    @"Green",
                          @"Miller",   @"Allen",     @"White",    @"Nelson",   @"Scott",nil];
    
    return [arrFamaly objectAtIndex:arc4random()%[arrFamaly count]];
}



-(NSString*) randomName {
    
    
    NSArray* arrName = [NSArray arrayWithObjects:   @"James",    @"Charles",    @"Donald",   @"Anthony",    @"Jeff",
                        @"John",     @"Joseph",     @"George",   @"Kevin",      @"Mary",
                        @"Robert",   @"Thomas",     @"Kenneth",  @"Jason",      @"Linda",
                        @"Michael",  @"Christopher",@"Steven",   @"Barbara",    @"Susan",
                        @"William",  @"Daniel",     @"Edward",   @"Elizabeth",  @"Margaret",
                        @"David",    @"Paul",       @"Ronald",   @"Jennifer",   @"Lisa",
                        @"Richard",  @"Mark",       @"Brian",    @"Maria",      @"Nancy",nil];
    
    return [arrName objectAtIndex:arc4random()%[arrName count]];
}



@end
