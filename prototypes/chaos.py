import random

class ChaosEvent():
    def __init__(self, text, effects):
        self.text = text
        self.effects = effects

    def apply(self, room):
        for e in self.effects:
            action, increase, factor = e
            room[action] += increase
            room[action] *= factor
        return room

EVENTS = [
    ChaosEvent("Du hast was feines gekocht", [("abwasch", 1, 1)]),
    ChaosEvent("Du hast was nicht so feines gekocht", [("abwasch", 0, 2)]),
    ChaosEvent("Du hast Dich im Restaurant eingesaut, Du Ferkel!", [("wäsche", 1, 1)]),
    ChaosEvent("Du hast es leider nicht bis zum Klo geschafft...", [("wäsche", 2, 1)]),
    ChaosEvent("Die Deadline rückt näher...", [("arbeit", 3, 1)]),
    ChaosEvent("Dein Hund hat Deine Hausaufgaben gefressen... und wieder ausgekackt", [("arbeit", 1, 1), ("müll", 1, 1)]),
    ChaosEvent("Dein Computer ist abgestürzt und Du musst alles nochmal machen...", [("arbeit", 0, 2)]),
    ChaosEvent("SO VIEL ZU TUN!", [("arbeit", 4, 1)]),
    ChaosEvent("Pyjama Party!", [("wäsche", 2, 1), ("abwasch", 2, 1)]),
    ChaosEvent("Mottenattacke!", [("wäsche", 2, 1)]),
    ChaosEvent("So langsam stinkts hier", [("müll", 2, 1)]),
    ChaosEvent("VERPACKUNGSWAHN!", [("müll", 4, 1)]),
    ChaosEvent("Endlich Wochende", [("müll", 0, 1)]),
]

class ChaosGame():
    def __init__(self) -> None:
        self.day = 0
        self.TOLERABLE_CHAOS = 10
        self.actions = ["müll", "abwasch", "wäsche", "arbeit", "pflanzen"]
        self.happiness = 5
        self.n_actions = 3
        self.clean_effect = 1
        self.events = EVENTS
        self.room = dict()
        for a in self.actions:
            self.room[a] = 0

    def input_action(self):
        text = "Welche Aktion möchtest Du durchführen?"
        a = ""
        while not a in self.actions:
            a = input("{}: ".format(text))
        return a
    
    def clamp_chaos(self):
        for a in self.actions:
            self.room[a] = max(0, self.room[a])
            self.room[a] = min(self.room[a], 5)
    
    def next_day(self):
        self.day += 1
        #self.happiness -= 1
        print("-" * 40)
        print("TAG", self.day)
        print("-" * 40)
        self.room["pflanzen"] += 1
        e = random.choice(self.events)
        print(e.text)
        self.room = e.apply(self.room)
        self.clamp_chaos()
        print(self.room)
        if self.total_chaos() > self.TOLERABLE_CHAOS or self.happiness <= 0:
            return False
        return True
    
    def clean_up(self, action):

        self.room[action] = max(0, self.room[action] - self.clean_effect)
        self.clamp_chaos()
        print(self.room)
    
    def make_move(self):
        for n in range(self.n_actions):
            a = self.input_action()
            self.clean_up(a)
    
    def total_chaos(self):
        return sum([self.room[a] for a in self.actions])

if __name__ == "__main__":
    game = ChaosGame()
    while game.next_day():
        game.make_move()
    print("Das Chaos siegt...")
