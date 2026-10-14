# NSE Daily Index Candles

Incremental archive of NSE **Daily Snapshot (csv)** index OHLC data. Files are stored under `Day_Index/NSE` using NSE's `ind_close_all_DDMMYYYY.csv` naming.

Canonical repository: [olo-ai-training-data-nse-day-index-candle](https://github.com/olo-labs/olo-ai-training-data-nse-day-index-candle).

```powershell
git clone https://github.com/olo-labs/olo-ai-training-data-nse-day-index-candle.git
cd olo-ai-training-data-nse-day-index-candle
git pull --ff-only origin main
```

Run `index_data_downloader.bat`, or:

```powershell
.\download_index_data.ps1 -StartDate '2025-01-01' -EndDate '2025-12-31'
```

The downloader skips existing files, ignores weekends/404 holidays, validates the index OHLC header, and moves only validated downloads into the dataset. This independent community project is not affiliated with NSE. NSE data rights and terms remain applicable.

