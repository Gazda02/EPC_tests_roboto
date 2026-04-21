# Testy EPC – część Michała Brzezińskiego

Dokument opisuje zakres prac wykonanych w ramach mojej części projektu testów automatycznych dla symulatora EPC (Evolved Packet Core). Odpowiada on za testy związane z:

- domyślnym bearerem (ID 9),
- dodawaniem dedykowanych bearerów,
- usuwaniem bearerów,
- resetowaniem symulatora,
- przygotowaniem wspólnych keywordów (warstwa 1.5 i warstwa 2),
- ujednoliceniem struktury testów i tagów.

Całość została wykonana zgodnie z wymaganiami projektu, dokumentacją EPC oraz zasadami AAA (Arrange–Act–Assert).

---

## 1. Zakres wykonanych scenariuszy testowych

### ### **1.1. Default bearer (ID 9)**  
Plik: `tests/bearer/default_bearer.robot`

Wykonane scenariusze:

- **Attached UE has default bearer with ID 9**  
  Po podłączeniu UE automatycznie tworzony jest domyślny bearer 9.

- **Removing default bearer should fail**  
  Próba usunięcia bearera 9 zwraca błąd 400 i bearer pozostaje aktywny.

Tagi: `bearer`, `default`, `positive` / `negative`

---

### **1.2. Dodawanie bearerów (add bearer)**  
Plik: `tests/bearer/add_bearer.robot`

Wykonane scenariusze:

- dodanie bearera z poprawnymi parametrami,
- walidacja odpowiedzi (UE ID, bearer ID, status),
- testy brzegowe (ID 1 i 8),
- testy błędów (ID 0, ID 10),
- testy typu błędu (`greater_than_equal`, `less_than_equal`),
- dodanie istniejącego bearera (400),
- dodanie bearera do nieistniejącego UE (400),
- dodanie bearera bez ID (422).

Tagi:  
`bearer`, `add`, `positive`, `negative`, `boundary`, `error-type`, `duplicate`, `invalid-ue`, `invalid-bearer`, `missing-id`

---

### **1.3. Usuwanie bearerów (remove bearer)**  
Plik: `tests/bearer/remove_bearer.robot`

Wykonane scenariusze:

- usunięcie aktywnego bearera (200),
- usunięcie nieaktywnego bearera (200),
- walidacja odpowiedzi (UE ID, bearer ID, status),
- usunięcie nieistniejącego bearera (400),
- usunięcie bearera bez ID (422),
- próba usunięcia bearera domyślnego (400).

Tagi:  
`bearer`, `remove`, `positive`, `negative`, `invalid-bearer`, `missing-id`, `default`, `response`

---

### **1.4. Resetowanie symulatora (reset EPC)**  
Plik: `tests/reset/reset_simulator.robot`

Wykonane scenariusze:

- reset w stanie bez UE,
- reset w stanie z aktywnym UE i bearerami,
- reset usuwa wszystkie UEs i bearery (test integracyjny).

Tagi:  
`reset`, `simulator`, `positive`, `cleanup`, `integration`

---

## 2. Architektura keywordów

### **Warstwa 3 – API (`EPC_API.robot`)**
- surowe wywołania HTTP (`GET`, `POST`, `DELETE`),
- operacje domenowe: `Attach UE`, `Delete Bearer`, `Get All UEs`, `Reset EPC`.

### **Warstwa 2 – keywordy domenowe (`EPC_Bearers_Keywords.robot`)**
- logika biznesowa bez asercji,
- operacje: `Add Bearer To UE`, `Remove Bearer From UE`,
- asercje stanu UE:  
  `UE With ID Should Have Bearer`,  
  `UE With ID Should Not Have Bearer`.

### **Warstwa 1.5 – keywordy wysokopoziomowe (`EPC_Bearers_HighLevel.robot`)**
- opisowe keywordy używane w testach,
- zawierają asercje i logikę testową,
- przykłady:  
  `Add Bearer With ID … Should Succeed`,  
  `Delete Bearer With ID … Should Fail With Status 400`.

---

## 3. Struktura testów i konwencje

- Każdy test stosuje wzorzec **AAA (Arrange–Act–Assert)**.
- Każdy plik testowy posiada **Test Teardown = Reset EPC**.
- Tagi są spójne z tagami pozostałych członków zespołu.
- Nazwy testów są opisowe i zgodne z wymaganiami prowadzącego.
- Testy nie mieszają warstw — logika jest w keywordach, nie w testach.

---

## 4. Jak uruchomić testy

Uruchomienie całej mojej części:

```bash
robot tests/bearer
robot tests/reset
```

Uruchomienie tylko testów reset:

```bash
robot --include reset tests
```

Uruchomienie tylko testów dodawania bearerów:

```bash
robot --include add tests
```

5. Podsumowanie
Wszystkie przypisane mi scenariusze zostały:

- zaimplementowane,

- otagowane,

- zintegrowane z architekturą projektu.

Dodatkowo przygotowałem:

- warstwę 1.5 keywordów,

- refaktor keywordów domenowych,

- ujednolicenie struktury testów,

- test integracyjny dla resetu.