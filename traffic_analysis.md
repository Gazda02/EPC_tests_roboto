# Analiza Rozbieżności: Dokumentacja vs. Rzeczywistość

Dokument zawiera zestawienie różnic pomiędzy specyfikacją a faktycznym zachowaniem API EPC.

Weryfikacja została wykonana na uruchomionym API (lokalnie), na podstawie realnych odpowiedzi HTTP.

## 1. Procedura Zatrzymania Ruchu (Stop Traffic)
*   **Dokumentacja:** Informuje o możliwości zakończenia przesyłania danych.
*   **Obserwacja:** Po `DELETE /ues/10/bearers/9/traffic` wartości `tx_bps/rx_bps` nie wyzerowały się (utrzymywały się na `99012519`).
*   **Obserwacja metadanych:** `protocol=tcp` i `target_bps=50000000` pozostały ustawione po zatrzymaniu.
*   **Rozbieżność:** Stan po zatrzymaniu ruchu nie odzwierciedla zakończenia transmisji.

## 2. Limity i Spójność Agregacji (UE Summary)
*   **Dokumentacja:** Maksymalny transfer `100 Mbps` dla UE w kierunku DL oraz możliwość sprawdzenia transferu sumarycznego.
*   **Obserwacja:** Dla bearerów `9/1/5` z targetami `10/20/30 Mbps`:
    *   `bearer_count=3` (poprawnie),
    *   `total_tx_bps=120387550`, `total_rx_bps=120387550` (znacząco powyżej sumy targetów `60000000`).
*   **Rozbieżność:** API raportuje przepustowość UE przekraczającą deklarowany limit `100 Mbps`.

## 3. Niespójność Obsługi Błędów (Error Handling)
*   **Obserwacja:**
    *   `GET /ues/999/bearers/9/traffic` -> `400 Bad Request`, `{"detail":"UE not found"}`,
    *   `GET /ues/10/bearers/99/traffic` -> `200 OK` z `protocol=null`, `target_bps=null`, `tx_bps=0`, `rx_bps=0`.
*   **Rozbieżność:** Swagger dla tych endpointów opisuje głównie `200` i `422`, ale API zwraca też `400` dla przypadku „UE not found”.

## 4. Parametry opcjonalne i Jednostki
*   **Dokumentacja:** Wspomina parametr `unit` i domyślną jednostkę `kbps`.
*   **Obserwacja:** Zapytanie z `?unit=kbps` nadal zwraca pola `tx_bps/rx_bps` w `bps`.
*   **Rozbieżność:** Zachowanie API jest niespójne z opisem jednostek w dokumentacji Markdown.

## 5. Zakresy identyfikatorów (UE ID)
*   **Dokumentacja Markdown:** Zakres `0-100`.
*   **Obserwacja:** `ue_id=0`, `ue_id=-1`, `ue_id=101` -> każdorazowo `422 Unprocessable Entity`.
*   **Rozbieżność:** Faktyczny zakres to `1-100` (błąd off-by-one w `documentation.md`).

## 6. Statusy błędów Walidacji
*   **Obserwacja:** System używa dwóch klas błędów:
    *   `422` dla walidacji danych wejściowych (np. zakres `ue_id`),
    *   `400` dla błędu domenowego „UE not found” przy sprawdzaniu ruchu.
*   **Rozbieżność:** Rozdział kodów jest technicznie sensowny, ale niekompletnie opisany w dokumentacji API.

## 7. Dlaczego testy zakończenia traffic kończą się FAIL
*   **Testy:** `Test end traffic for single bearer` oraz `Test end traffic for all bearers`.
*   **Co sprawdzają testy:** Po `Stop Traffic` wykonywany jest `Check Traffic` i asercja, że `tx_bps=0` oraz `rx_bps=0`.
*   **Co zwraca API:** Po zatrzymaniu ruchu API nadal zwraca niezerowe wartości throughput (np. `8287500493 != 0` dla single bearer i `2566108289 != 0` dla all bearers).
*   **Wniosek:** Fail tych testów jest poprawny i wskazuje na błąd backendu w obsłudze stanu po `Stop Traffic` (brak wyzerowania throughput).

