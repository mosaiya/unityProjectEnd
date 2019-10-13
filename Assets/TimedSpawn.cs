using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityStandardAssets.CrossPlatformInput;

public class TimedSpawn : MonoBehaviour
{
    public Transform[] spawnPointsT;
    public GameObject hazard;
    public GameObject alert;
    public GameObject image;
    public GameObject[] spawnPoints;
    public GameObject countzombie;
    public Text Textcountzombie;
    public int hazardCount;
    public float SpawnWait;
    public float starWait;
    public float waveWait;
    public Text Numawave;
    int save  ;
    int wave = 0;
    public int SpawnWave = 10;

    public bool check = true;
    void Start()
    {
        save = 0;
        spawnPoints = GameObject.FindGameObjectsWithTag("spawnPoint");
    }
    int GetRandom(int count)
    {
        int random;
        while (true)
        {
             random = Random.Range(0, count);
            if (Vector3.Distance(spawnPointsT[random].position, this.transform.position) < 100)
            {
                break;
            }
        }
        
        return random;
    }
    IEnumerator SpawnWaves() 
    {
        Textcountzombie.text = save.ToString()+"/"+ SpawnWave.ToString();
        Debug.Log(save);
        check = false ;
        
            for (int i = 0; i < SpawnWave ; i++)
            {
            Debug.Log(spawnPoints.Length);
                int randomInt = GetRandom(spawnPoints.Length);
                Quaternion spawnRotation = Quaternion.identity;
            Instantiate(hazard, spawnPoints[randomInt].transform.position, spawnPoints[randomInt].transform.rotation);
            Debug.Log("spawned");
            yield return new WaitForSeconds(SpawnWait);
            alert.SetActive(false);
        }
           
    }
    void Update()
    {
      if (!check && countzombie.active == false)
        {
                save++;
            Debug.Log(save);
            Textcountzombie.text = save.ToString() + "/" + SpawnWave.ToString(); 
                countzombie.SetActive(true);
                Debug.Log(save);
               if (save == 0)
            {
                
                check = true;
                countzombie.SetActive(false);
                image.SetActive(false);
                Numawave.text = "WAVE END";
                SpawnWave += 5;
                save = SpawnWave;
            }
                
            
        }
        
    }
    
    void OnParticleCollision(GameObject other)
    {
        int i = 100;
        if (other.tag == "zombie")
        {
            i--;
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "spawn")
        {

            if (check)
            {
                wave++;
                image.SetActive(true);
                countzombie.SetActive(true);
                alert.SetActive(true);
                Destroy(other.gameObject);
                Numawave.text = wave.ToString();
                StartCoroutine(SpawnWaves());
            }
        }
       


    }
}


